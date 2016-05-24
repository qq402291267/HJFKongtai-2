//
//  comMethod.h
//  HJFminshi
//
//  Created by 胡江峰 on 16/3/7.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface comMethod : NSObject

//16进制
+ (UInt16)uint16FromNetData:(NSData *)data;

//data转ip
+ (NSString *)convertDataToip:(NSData *)data;

//data转string
+ (NSString *)convertDataTomacstring:(NSData *)data;

//string转data
+ (NSData *)convertmacstringToData:(NSString *)macstring;

//得到文本输入左侧空视图
+ (UIView *)gettextRectLeftView;

//得到宽度和高度

+ (CGSize) titleSizeWithTitle:(NSString *)title size:(CGFloat)size;

+ (CGSize) titleSizeWithTitle:(NSString *)title size:(CGFloat)size MaxW:(CGFloat)MaxW;

//判断userName和userPassword是否合法
+(BOOL)JudgeUserName:(NSString *)userName userPassword:(NSString *)userPassword;

//警告框
+ (UIAlertView *)showAlertWithTitle:(NSString *)title msg:(NSString *)msg;

+ (void)RGBtoHSVr:(float)r g:(float)g b:(float)b h:(float *)h s:(float *)s v:(float *)v;

//获得app的代理
+ (AppDelegate *)getAppDelegate;

//获取一点的颜色
+ (UIColor *)getPixelColorAtLocation:(CGPoint)point imagedata:(UIImage *)imagedata;
+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color;

@end
