//
//  RemoteService.m
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/16.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "RemoteService.h"

@interface RemoteService()
{
    BOOL IsUseSsl;
}
@property (nonatomic,assign) TcpConnectStatus currentConnectStatus;
@property (nonatomic,strong) NSMutableArray * allOperationArray;
@property (nonatomic,assign) NSTimeInterval intervalheat;//定时时间
@property (nonatomic,strong) NSTimer * connecttimeoutTimer;//连接超时定时器
@property (nonatomic,strong) NSTimer * heartbeatTimer;
@property (nonatomic,strong) NSTimer * disconnectTimer;
@property (nonatomic,strong) GCDAsyncSocket * currentSocket;
@property (nonatomic,strong) NSMutableData * responseData;
@end


static RemoteService * singleInstance = nil;

@implementation RemoteService

+ (RemoteService * )shareRemoteService{
    if (singleInstance == nil) {
        singleInstance = [[RemoteService alloc] init];
    }
    return singleInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        _currentConnectStatus = NotConnected;
        _allOperationArray = [[NSMutableArray alloc] init];
        _intervalheat = 10;
        IsUseSsl = NO;
    }
    return self;
}

//  判断连接并开启定时器
- (void)JudgeConnect{
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_StoreageUSERNAME];
    NSString * userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_StoreageUSERPASSWORD];
    if ([comMethod JudgeUserName:userName userPassword:userPassword]){
        
        [self connectfunction];
    }
    else {
        HJFTCPLog(@"用户未登录,不能连接Tcp服务器");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //开启定时器判断Tcp是否已经连接,如果延时30s后连接仍然未建立,则reconnect
        [_connecttimeoutTimer invalidate];
        _connecttimeoutTimer = nil;
        _connecttimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(JudgeReconnect) userInfo:nil repeats:NO];
    });
}

//执行tcp连接动作
- (void)connectfunction{
    //判断是否已经连接上TCP服务器
    if (_currentConnectStatus == NotConnected)
    {
        //开始连接
        if ([NetworkUtilInstance networkStatus] != NotReachable)
            
        {
            HJFTCPLog(@"tcp未连接,开始连接");
            _currentConnectStatus = Connecting;
            [self connect];
        }
        else
        {
            HJFTCPLog(@"tcp未连接未连接,网络不可用");
        }
        
    }
    else if (_currentConnectStatus == Connecting)
    {
        HJFTCPLog(@"tcp正在连接");
    }
    else
    {
        HJFTCPLog(@"tcp设备已经连接");
        
    }
}


//U 口负载均衡服务器 cloud.kangtai.com.cn:29531
- (void)connect{
    //获取工作服务器
    [RemoteServiceGetWorkServerInstance connectgetWorkServerWithIsUseSSL:IsUseSsl Complete:^(ConnectStatus resultStatus, NSString *host, uint16_t port, NSString *failmsg) {
        if (resultStatus == ConnectStatus_failed) {
            //连接失败
            self.currentConnectStatus = NotConnected;
            HJFTCPLog(@"连接负载均衡服务器失败");
        }
        else
        { //连接成功,开始连接工作服务器
            self.currentSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:TcpUdpServiceInstance.single_Queue];
            HJFTCPLog(@"%@",[NSString stringWithFormat:@"开始连接工作服务器:host = %@,port = %d",host,port]);
            NSError * error = nil;
            //连接工作服务器
            if (![self.currentSocket connectToHost:host onPort:port error:&error]) {
                
                HJFTCPLog(@"连接工作服务器失败");
            }
        }
    }];
}

//判断是否需要重连
- (void)JudgeReconnect{
    if (_currentConnectStatus != Connected) {
        //未连接成功,断开重连
        [self reconnect];
    } else {
        //停止定时器
        [_connecttimeoutTimer invalidate];
        _connecttimeoutTimer = nil;
    }
}

//  服务器连接未成功,需要重连

- (void)reconnect{
    [self disconnect];
    HJFTCPLog(@"断开当前连接,重连服务器");
    [self JudgeConnect];
}


//  断开当前连接
- (void)disconnect{
    _currentSocket.delegate = nil;
    [_currentSocket disconnect];
    _currentSocket = nil;
    _currentConnectStatus = NotConnected;
    //设置设备tcp断线,并关闭定时器
    for (DevicePreF * deviceinfo in DeviceManageInstance.device_array) {
        deviceinfo.remoteIsOnline = NO;
    }
    //关闭心跳定时器
    [_heartbeatTimer invalidate];
    _heartbeatTimer = nil;
    [_disconnectTimer invalidate];
    _disconnectTimer = nil;
}

//---------------------------GCDAsyncSocketDelegate------------------------
//-------------------------------------------------------------------------

//使用ssl加密
/**
 * 适用与敏识需获取工作服务器项目
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (IsUseSsl) {
        //设置ssl字典
        NSDictionary * sslSetting = [self getsslSettingWithhost:TcpDataInstance.host];
        //开始设置SSL Setting
        HJFTCPLog(@"%@",[NSString stringWithFormat:@"SSL设置字典:sslSetting = %@",sslSetting]);
        
        if (sslSetting) {
            
            [_currentSocket startTLS:sslSetting];
        } else {
            HJFTCPLog(@"sslSetting设置为空,不能设置ssl");
            
        }
    } else {
        //不使用ssl,连接工作服务器成功,请求接入TCP
        //请求接入TCP-0x82
        [self requestTcpWorkServer];
    }
}

- (NSDictionary * )getsslSettingWithhost:(NSString *)host
{
    NSMutableDictionary *sslSettings = nil;
    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sslcer" ofType:@"p12"]];
    
    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(pkcs12data);
    CFStringRef password = CFSTR("123456");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
    CFRelease(options);
    CFRelease(password);
    
    /*
     @result errSecSuccess in case of success. errSecDecode means either the
     blob can't be read or it is malformed. errSecAuthFailed means an
     incorrect password was passed, or data in the container got damaged.
     */
    NSLog(@"securityError = %d",(int)securityError);
    
    if(securityError == errSecSuccess) {
        
        HJFLog(@">>>>>Success opening p12 certificate.");
        sslSettings = [[NSMutableDictionary alloc] init];
        
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef myIdent = (SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
        
        SecIdentityRef  certArray[1] = { myIdent };
        CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
        
        [sslSettings setObject:(id)CFBridgingRelease(myCerts) forKey:(NSString *)kCFStreamSSLCertificates];
        [sslSettings setObject:[NSNumber numberWithInt:2] forKey:GCDAsyncSocketSSLProtocolVersionMin];
        [sslSettings setObject:[NSNumber numberWithInt:8] forKey:GCDAsyncSocketSSLProtocolVersionMax];
        //#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [sslSettings setObject:[NSNumber numberWithBool:YES] forKey:GCDAsyncSocketManuallyEvaluateTrust];
        [sslSettings setObject:host forKey:(NSString *)kCFStreamSSLPeerName];
        
    } else if (errSecDecode == securityError){
        NSLog(@">>>>>Failed opening p12 certificate.:---->>errSecDecode");
    } else if (errSecAuthFailed == securityError) {
        NSLog(@">>>>>Failed opening p12 certificate.:---->>errSecAuthFailed");
    } else {
        NSLog(@">>>>>Failed opening p12 certificate.");
    }
    return sslSettings;
}

/**
 *  Allows a socket delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *  设备回调验证直接返回验证通过
 */
- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    completionHandler(YES);
}

//Called after the socket has successfully completed SSL/TLS negotiation.
//This method is not called unless you use the provided startTLS method.
- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    //请求接入TCP-0x82
    [self requestTcpWorkServer];
}

//Called when a socket disconnects with or without error.
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //
    _currentConnectStatus = NotConnected;
    [_currentSocket setDelegate:nil];
    [_currentSocket disconnect];
    _currentSocket = nil;
    HJFTCPLog(@"%@",[NSString stringWithFormat:@"连接断开:socketDidDisconnect,err = %@",[err localizedDescription]]);
    [self JudgeConnect];

}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    HJFTCPLog(@"%@",[NSString stringWithFormat:@"didReadData:tag = %ld,isMainThread = %d",tag,[NSThread isMainThread]]);
    
    if (tag == HeadNoHiddenTag) {
        _responseData = [[NSMutableData alloc] initWithData:data];
        //1.读取第一部分数据帧头未加密数据,得到需要读取的加密部分的长度

        UInt8 secondlength = ((UInt8 *)[data bytes])[8];
        HJFTCPLog(@"%@",[NSString stringWithFormat:@"读取第一部分数据完毕,开始读取第二部分数据:%@",data]);
        
        [_currentSocket readDataToLength:secondlength withTimeout:-1 tag:HiddenTag];
    } else {
        //得到第二部分数据
        [_responseData appendData:data];//<000002d1 f1341282 00>
        
        HJFTCPLog(@"%@",[NSString stringWithFormat:@"第二部分数据读取完毕,开始处理数据:_responseData = %@",_responseData]);//<a102ffff ffffffff 09000002 d1f13412 8200>
        
        //处理数据
        [self dealWithReceiveAllData];
        //处理完后开始读取下一次数据
        [_currentSocket readDataToLength:HeadNoHiddenLen withTimeout:-1 tag:HeadNoHiddenTag];
    }
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    HJFTCPLog(@"数据发送完成");
    
    
}
//--------------------------function---------------------------------------
//-------------------------------------------------------------------------
//请求接入TCP-0x82
- (void)requestTcpWorkServer
{
    HJFTCPLog(@"连接工作服务器成功,请求接入Tcp");
    //0x82请求接入TCP服务器
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_StoreageUSERNAME];
    NSString * userpassword = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_StoreageUSERPASSWORD];
    [_currentSocket readDataToLength:HeadNoHiddenLen withTimeout:-1 tag:HeadNoHiddenTag];
    NSData * senddata = [ProtocolData requestTcp:[IndexManagerInstance newIndex] username:username password:userpassword];
    [self sendToServerWithData:senddata complete:^(OperatorResult *resultData) {
        if (resultData) {
            //请求成功
            //此时认为TCP连接才算是真正建立
            self.currentConnectStatus = Connected;
            //TCP连接成功
            [self sendDataTcpConnected];
        } else {
            //请求失败
            self.currentConnectStatus = NotConnected;
            
            HJFTCPLog(@"请求连接Tcp失败");
            
            //重新连接TCP服务器
            [self reconnect];
        }
    }];
}



//   发送命令到当前连接的socket
- (void)sendToServerWithData:(NSData *)data complete:(Complete)delegate
{
    SocketOperator * currentOperator = [SocketOperator OperatorWithIndex:[IndexManagerInstance currentIndex] complete:delegate];
    
    HJFTCPLog(@"%@",[NSString stringWithFormat:@"tcp---------sendToServerWithData:index = %d,data = %@",currentOperator.currentIndex,data]);
    
    [currentOperator startTimer:TCPTimeout];
    [_allOperationArray addObject:currentOperator];
    [_currentSocket writeData:data withTimeout:-1 tag:0];
}


//  处理得到的所有数据_responseData
- (void)dealWithReceiveAllData
{
    UInt8 cmd = [TCP_ResponseAnalysisInstance getProtcolCmd:_responseData];
    NSDictionary *dictinfo = [[NSDictionary alloc] init];
    
    if (cmd == heartBeat) {
        dictinfo = [self serverheartBeatInfo:_responseData];
    }
    
    else{
        dictinfo = [TCP_ResponseAnalysisInstance analysisServerResponse:_responseData];
    }
    
    OperatorResult * result = [OperatorResult ResultWithdata:_responseData dictionary:dictinfo];
    
    HJFTCPLog(@"%@",[NSString stringWithFormat:@"1111OperatorResult = %@,isMainThread = %d",result,[NSThread isMainThread]]);
    //根据currentIndex找到对应操作,回调
    UInt16 currentIndex = [TCP_ResponseAnalysisInstance indexFromResponse:_responseData];
    SocketOperator * socketOperator = [self getIndexSoketOperator:currentIndex];
    if (socketOperator) {
        //关闭超时定时器
        [socketOperator closetimeoutTimer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [socketOperator didReceiveResponse:result];
            socketOperator.IsCalledback = YES;
        });
    }
}

//  根据序号找到对应的操作

- (SocketOperator *)getIndexSoketOperator:(UInt16)operatorIndex
{
    NSArray * tempOperatorArray = [NSArray arrayWithArray:_allOperationArray];
    for (SocketOperator * operator in tempOperatorArray) {
        if (operator.currentIndex == operatorIndex) {
            return operator;
        }
        //删除超时的操作
        if (operator.IsTimeout || operator.IsCalledback) {
            
            HJFTCPLog(@"%@",[NSString stringWithFormat:@"删除超时或已经回调操作:operator = %@",operator]);
            [_allOperationArray removeObject:operator];
        }
    }
    return nil;
}

//-----------------------------------------------------------------------
/**
 *  TCP连接成功
 */
- (void)sendDataTcpConnected
{
    //发送第一次心跳命令
    [self sendFirstheartbeat];
    for (DevicePreF * deviceinfo in DeviceManageInstance.device_array) {
        
        //订阅事件
        NSData * macdata = deviceinfo.macdata;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Tcpsubscribetoevent_Notification object:@{Mac_Key_data:macdata}];
        });
        //查询TCP是否在线
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:
             TcpIsonline_Notification object:@{Mac_Key_data:macdata}];
        });
        
    }
}

////--------------------------心跳检测处理-------------------------------------
////-------------------------------------------------------------------------

//  Tcp连接成功后,发送第一次心跳数据
- (void)sendFirstheartbeat
{
    [self sendheart];
    _intervalheat = 10;
    [_disconnectTimer invalidate];
    _disconnectTimer = nil;
    _disconnectTimer = [NSTimer scheduledTimerWithTimeInterval:_intervalheat*2.5 target:self selector:@selector(stopconnect) userInfo:nil repeats:NO];
}

//  发送心跳包
- (void)sendheart
{
    [self sendToServerWithData:[ProtocolData heartBeatserver:[IndexManagerInstance newIndex]] complete:^(OperatorResult *resultData)
     {
         if (resultData == nil) {
             HJFTCPLog(@"心跳包未接收到回复");
         }
         else {
             HJFTCPLog(@"心跳包收到回复");
             
         }
     }];
}

//  未检测到心跳,断开连接
- (void)stopconnect
{
    //重新连接TCP服务器
    [self reconnect];
}

// ************ 收到心跳包后会发出通知，并由此函数执行通知********************//


- (void)interval
{
    
    HJFTCPLog(@"%@",[NSString stringWithFormat:@"接收到tcp->notification心跳通知:isMainThread = %d,心跳数据:_intervalheat = %f",[NSThread isMainThread],_intervalheat]);
    [self startheartbeat];
    
}

//  执行心跳函数

- (void)startheartbeat
{
    //_intervalheat发送心跳数据
    [_heartbeatTimer invalidate];
    _heartbeatTimer = nil;
    _heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:_intervalheat target:self selector:@selector(sendheart) userInfo:nil repeats:NO];
    [_disconnectTimer invalidate];
    _disconnectTimer = nil;
    //心跳断开时间设置为2.5倍interval
    _disconnectTimer = [NSTimer scheduledTimerWithTimeInterval:_intervalheat*2.5 target:self selector:@selector(stopconnect) userInfo:nil repeats:NO];
}

//---------------------------------------------------------------------------------






//  处理服务器心跳数据0x61
- (NSDictionary *)serverheartBeatInfo:(NSData *)response
{
    @try {
        //
        _intervalheat = [comMethod uint16FromNetData:[response subdataWithRange:NSMakeRange(17, 2)]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self interval];
            
        });
        return @{@"interval": [NSString stringWithFormat:@"%f",_intervalheat]};
        
    } @catch (NSException *exception) {
        //
        HJFTCPLog(@"serverheartBeatInfo>>>exception = %@",exception);
        return nil;
    }
}






@end
