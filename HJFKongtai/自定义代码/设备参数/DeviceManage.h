//
//  DeviceManageInstance.h
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/16.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DeviceManageInstance [DeviceManage shareAllDevice]
@interface DeviceManage : NSObject
@property (nonatomic,strong) NSMutableArray * device_array;
+ (DeviceManage *)shareAllDevice;

//判断设备存在
- (BOOL)IsExistsWithmacstr:(NSString *)macstr;

//数据转换
- (void)convertDeviceinfo:(DevicePreF *)deviceinfo;

//通过mac获取设备
- (DevicePreF *)getDevicePreFWithmac:(NSData *)mac;
@end
