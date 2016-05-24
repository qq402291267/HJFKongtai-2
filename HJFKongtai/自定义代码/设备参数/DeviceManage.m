//
//  DeviceManageInstance.m
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/16.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "DeviceManage.h"
static DeviceManage * singleInstance = nil;
@implementation DeviceManage
+ (DeviceManage *)shareAllDevice{
    if (singleInstance == nil) {
        singleInstance = [[DeviceManage alloc] init];
    }
    return singleInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        _device_array = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceOn_Off_StatusNotification:) name:GetDeviceStatus_Notification object:nil];
    }
    return self;
}

-(void)getDeviceOn_Off_StatusNotification:(NSNotification*)notification{
    NSDictionary * dict = [notification object];
    NSData * macdata = [dict objectForKey:Mac_Key_data];
    DevicePreF *deviceinfo = [DeviceManageInstance getDevicePreFWithmac:macdata];
    [self getDeviceOn_Off_StatusWithDevice:deviceinfo];
}

-(void)getDeviceOn_Off_StatusWithDevice:(DevicePreF*)deviceinfo;
{
    HJFLog(@"查询设备信息");
    if (deviceinfo == nil) {
        NSLog(@"查询设备信息,设备不存在");
        return;
    }
    NSData * senddata = [ProtocolData getDeviceIOStatus:[IndexManagerInstance newIndex] controlType:0x00 deviceinfo:deviceinfo isremote:!deviceinfo.localIsOnline];
    [TcpUdpServiceInstance sendData:senddata deviceinfo:deviceinfo complete:^(OperatorResult *resultData) {
        
    }];
}

//判断设备是否存在
- (BOOL)IsExistsWithmacstr:(NSString *)macstr
{
    BOOL isExists = NO;
    for (DevicePreF * currentdevice in _device_array) {
        if ([currentdevice.macAddress isEqualToString:macstr]) {
            isExists = YES;
            break;
        }
    }
    return isExists;
}


//转化数据
- (void)convertDeviceinfo:(DevicePreF *)deviceinfo
{
    if (deviceinfo == nil) {
        return;
    }
    if (deviceinfo.macdata == nil) {
        deviceinfo.macdata = [ comMethod convertmacstringToData:deviceinfo.macAddress];
    }
    //companyCodevalue
    NSData * companyCodevaluedata = [comMethod convertmacstringToData:deviceinfo.companyCode];
    deviceinfo.companyCodevalue = ((UInt8 *)[companyCodevaluedata bytes])[0];
    //deviceTypevalue
    NSData * deviceTypevaluedata = [comMethod convertmacstringToData:deviceinfo.deviceType];
    deviceinfo.deviceTypevalue = ((UInt8 *)[deviceTypevaluedata bytes])[0];
    //authCodedata
    deviceinfo.authCodedata = [comMethod  convertmacstringToData:deviceinfo.authCode];
}

//通过mac获取设备
- (DevicePreF*)getDevicePreFWithmac:(NSData *)mac
{
    
    DevicePreF * deviceInfo = nil;
    for (DevicePreF * currentdevice in _device_array)
    {
        
        if ([currentdevice.macdata isEqualToData:mac]) {
            deviceInfo = currentdevice;
            break;
        }
    }
    return deviceInfo;
}








@end
