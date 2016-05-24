//
//  TCPMethod.h
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/16.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TCPMethodInstance [TCPMethod shareTCPMethod]

@interface TCPMethod : NSObject
+ (TCPMethod *)shareTCPMethod;

- (void)JudgeConnect;

@end

