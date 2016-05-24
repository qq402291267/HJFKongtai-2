//
//  DevicePreF.h
//  HJFkongtai
//
//  Created by 胡江峰 on 16/5/14.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DevicePreFdefine.h"
@interface DevicePreF : NSObject

//授权码
@property (nonatomic,copy) NSString* authCode;

@property (nonatomic,copy) NSData* authCodedata;
//厂家代码
@property (nonatomic,copy) NSString* companyCode;

@property (nonatomic,assign) UInt8 companyCodevalue;

//设备名称
@property (nonatomic,copy) NSString* deviceName;

//设备类型
@property (nonatomic,copy) NSString* deviceType;

@property (nonatomic,assign) UInt8  deviceTypevalue;

//图片文件名
@property (nonatomic,copy) NSString* imageName;

//最后更新时间
@property (nonatomic,copy) NSString* lastOperation;

//MAC地址
@property (nonatomic,copy) NSString* macAddress;

@property (nonatomic,copy) NSData* macdata;

//排序号
@property (nonatomic,assign) int orderNumber;


//远程是否在线
@property (nonatomic,assign) BOOL remoteIsOnline;

//  设备局域网是否在线
@property (nonatomic,assign) BOOL localIsOnline;



#pragma mark - serverversion data 服务器最新版本信息
//-------------------------------------------------------
//  最新版本号长度
@property (nonatomic,assign) int newversionlen;

//  最新设备版本号 data数据
@property (nonatomic,strong) NSData * newversiondata;

//  最新设备版本号 stirng数据
@property (nonatomic,strong) NSString * newversion;

//  升级url长度
@property (nonatomic,assign) int updateurllen;

//  升级url data数据
@property (nonatomic,strong) NSData * updateurldata;

//  升级url string数据
@property (nonatomic,strong) NSString * updateurl;
//-------------------------------------------------------

//  局域网心跳时间间隔
@property (nonatomic,strong) NSTimer * heartbeatTimer;

@property (nonatomic,strong) NSTimer * stopheartTimer;

@property (nonatomic,assign) UInt16 udpinterval;

// 设备局域网IP
@property (nonatomic,copy) NSString * lanIP;

//  用户名
@property (nonatomic,copy) NSString * username;

//  局域网设备是否被锁定
@property (nonatomic,assign) BOOL islock;

#pragma mark - deviceversion data 设备当前版本信息及别名
//-------------------------------------------------------
//   硬件版本长度
@property (nonatomic,assign) UInt8 hlen;

//   硬件版本号 data
@property (nonatomic,strong) NSData * hversiondata;

//   硬件版本号 str
@property (nonatomic,strong) NSString * hversionstr;

//  软件版本长度
@property (nonatomic,assign) UInt8 slen;

//  软件版本号 data
@property (nonatomic,strong) NSData * sversiondata;

//  软件版本号 str
@property (nonatomic,strong) NSString * sversionstr;

//    别名长度
@property (nonatomic,assign) UInt8 alisalen;

//  别名 data
@property (nonatomic,strong) NSData * alisadata;

//  别名 str
@property (nonatomic,strong) NSString * alisastr;

//  设备上电
@property (nonatomic,assign) BOOL deviceOn;

+ (DevicePreF * )AllInfo;


@end
