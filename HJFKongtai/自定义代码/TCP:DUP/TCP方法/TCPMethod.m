//
//  TCPMethod.m
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/16.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "TCPMethod.h"

static TCPMethod * signleInstance = nil;
@implementation TCPMethod

//tcp链接
- (void)JudgeConnect{
    [RemoteServiceInstance JudgeConnect];
}

+ (TCPMethod *)shareTCPMethod{
    if (signleInstance == nil) {
        signleInstance = [[TCPMethod alloc] init];
    }
    return signleInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TcpIsonline:) name:TcpIsonline_Notification object:nil]; //udp查询在线,以及收到第一个tcp心跳包后
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Tcpsubscribetoevent:) name:Tcpsubscribetoevent_Notification object:nil];//udp查询订阅，以及收到第一个tcp心跳包后
    }
    return self;
}

//****************************************************************************//
//Tcp设备查询设备是否在线通知 0x84，设备在线后发送 UpdateStatus_Notification通知,如果是在线，
//发送GetDeviceStatus_Notification
- (void)TcpIsonline:(NSNotification *)notification{
    NSDictionary  *dict =[notification object];
    NSData * macdata = [dict objectForKey:Mac_Key_data];
    DevicePreF * deviceinfo = [DeviceManageInstance getDevicePreFWithmac:macdata];
    [RemoteServiceInstance sendToServerWithData:[ProtocolData getonlinestatusWithdeviceinfo:deviceinfo index:NewIndex] complete:^(OperatorResult *resulData) {
        
    }];
}


//---------------------------订阅TCP事件------------------------------------------
//订阅事件通知 0x83   订阅事件未在ui中显示
-(void)Tcpsubscribetoevent:(NSNotification *)notification{
    
    
    NSDictionary  *dict =[notification object];
    NSData * macdata = [dict objectForKey:Mac_Key_data];
    DevicePreF* deviceinfo = [DeviceManageInstance getDevicePreFWithmac:macdata];
    if (deviceinfo) {
        //订阅设备上线/离线事件:0x85
        NSData * senddata = [ProtocolData subscribetoeventsWithdeviceinfo:deviceinfo index:NewIndex issub:YES cmd:0x85];
        HJFTCPLog(@"订阅设备上线/离线事件:0x85");
        [RemoteServiceInstance sendToServerWithData:senddata complete:^(OperatorResult *resultData) {
            if (resultData) {
                HJFTCPLog(@"0x85订阅成功");
            } else {
                HJFTCPLog(@"0x85订阅失败,开始再次订阅");
                NSData * secondsenddata = [ProtocolData subscribetoeventsWithdeviceinfo:deviceinfo index:NewIndex issub:YES cmd:0x85];
                [RemoteServiceInstance sendToServerWithData:secondsenddata complete:^(OperatorResult *resultData) {
                    if (resultData) {
                        HJFTCPLog(@"0x85订阅成功");
                    } else {
                        HJFTCPLog(@"0x85订阅失败");
                    }
                }];
            }
        }];
        
        //0x0F设备主动上报数据
        senddata = [ProtocolData subscribetoeventsWithdeviceinfo:deviceinfo index:NewIndex issub:YES cmd:0x0F];
        [RemoteServiceInstance sendToServerWithData:senddata complete:^(OperatorResult *resultData) {
            if (resultData) {
                HJFTCPLog(@"0x0f订阅成功");
            } else {
                HJFTCPLog(@"0x0f订阅失败,开始再次订阅");
                NSData * secondsenddata = [ProtocolData subscribetoeventsWithdeviceinfo:deviceinfo index:NewIndex issub:YES cmd:0x0F];
                [RemoteServiceInstance sendToServerWithData:secondsenddata complete:^(OperatorResult *resultData) {
                    if (resultData) {
                        HJFTCPLog(@"0x0f订阅成功");
                    } else {
                        HJFTCPLog(@"0x0f订阅失败");
                        
                    }
                }];
            }
        }];
        //其他事件
    }
    
    
}


@end
