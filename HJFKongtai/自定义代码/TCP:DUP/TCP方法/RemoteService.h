//
//  RemoteService.h
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/16.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#define RemoteServiceInstance [RemoteService shareRemoteService]

typedef enum
{
    NotConnected  = 0,
    Connecting    = 1,
    Connected     = 2
} TcpConnectStatus;

@interface RemoteService : NSObject

+ (RemoteService * )shareRemoteService;

/**
 *  判断连接并开启定时器
 */
- (void)JudgeConnect;

/**
 *  发送命令到当前连接的socket
 *
 *  @param data     要发送的全部数据
 *  @param delegate 代理回调
 */
- (void)sendToServerWithData:(NSData *)data complete:(Complete)delegate;

@end
