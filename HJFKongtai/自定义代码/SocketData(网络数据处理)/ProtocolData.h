//
//  ProtocolData.h
//  Minshi
//
//  Created by 胡江峰 on 16/1/8.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DevicePreF.h"
typedef enum {
    getDeviceInfoType_ledRGB = 1,
    getDeviceInfoType_ledModel,
    getDeviceInfoType_antomization,
    getDeviceInfoType_offtime,
    deleteDeviceType_offtime
} getDeviceInfoType;

@interface ProtocolData : NSObject


#pragma mark - tcp

//  获取工作服务器
+ (NSData *)workingServer:(UInt16)index;

//  请求接入Tcp服务器0x82
+ (NSData *)requestTcp:(UInt16)index username:(NSString *)username password:(NSString *)password;

//  订阅/取消订阅事件0x83
+ (NSData *)subscribetoeventsWithdeviceinfo:(DevicePreF *)deviceinfo index:(UInt16)index issub:(BOOL)issub cmd:(UInt8)cmd;

// 查询设备是否在线0x84
 + (NSData *)getonlinestatusWithdeviceinfo:(DevicePreF *)deviceinfo index:(UInt16)index;

////  获取设备最新固件版本信息0x86
//+ (NSData *)getnewversionWithdeviceinfo:(DevicePreF *)deviceinfo index:(UInt16)index;

//  发送心跳包到服务器
+ (NSData *)heartBeatserver:(UInt16)index;

#pragma mark - udp

// udp发现设备0x23
+ (NSData *)discorverdevice:(UInt16)index deviceinfo:(DevicePreF *)deviceinfo;

////  udp锁定解锁设备0x24
//+ (NSData *)lockunlockdevice:(UInt16)index lock:(BOOL)islock deviceinfo:(DevicePreF *)deviceinfo;

//  udp发送心跳包0x61

+ (NSData *)heartBeatLocal:(UInt16)index deviceinfo:(DevicePreF *)deviceinfo;

#pragma mark - tcp/udp

//  0x62查询模块信息
+ (NSData *)getcurrentdeviceVersion:(UInt16)index deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

//  0x63设置模块别名
+ (NSData *)setdevicealisa:(UInt16)index alisalen:(UInt8)alisalen alisadata:(NSData *)alisadata deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

//  0x65模块固件升级
+ (NSData *)updatedevice:(UInt16)index urllen:(UInt8)urllen urldata:(NSData *)urldata deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

#pragma mark - 产品专用命令

//  组包设备共有信息(仅有第一个命令字节)
+ (NSData *)commonDeviceInfoWithType:(getDeviceInfoType)Type index:(UInt16)index deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

// 0x01控制设备状态

+ (NSData *)setDeviceIOStatus:(UInt16)index controlType:(UInt8)controlType controlStatus:(UInt8)controlStatus deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

//  0x02查询设备状态
+ (NSData *)getDeviceIOStatus:(UInt16)index controlType:(UInt8)controlType deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

//  0x03设置LED灯颜色/亮度
+ (NSData *)setDeviceledRGB:(UInt16)index Rvalue:(UInt8)Rvalue Gvalue:(UInt8)Gvalue Bvalue:(UInt8)Bvalue deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

//  0x05 设置LED工作模式
+ (NSData *)setLedModel:(UInt16)index model:(UInt8)model deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

//  0x07 设置雾化度
+ (NSData *)setatomization:(UInt16)index atomization:(UInt8)atomization deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

// 0x09 设置倒计时
+ (NSData *)setofftime:(UInt16)index time:(long)time deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

//  0x0C设置预约
+ (NSData *)setBookWithindx:(UInt16)index Num:(UInt8)num Flag:(UInt8)flag Hour:(UInt8)hour Min:(UInt8)min isOpen:(BOOL)isOpen deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

// 0x0d查询预约

+ (NSData *)getBookDataWithindex:(UInt16)index Numdata:(NSData *)numData deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;

//  0x0e删除预约
+ (NSData *)deleteBookWithindex:(UInt16)index Num:(UInt8)num deviceinfo:(DevicePreF *)deviceinfo isremote:(BOOL)isremote;


@end
