//
//  TCPUDPdefine.h
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/16.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#ifndef TCPUDPdefine_h
#define TCPUDPdefine_h

#ifdef __OBJC__
#import "SocketOperator.h"
#import "SocketError.h"
#import "RemoteService.h"
#import "RemoteServiceGetWorkServer.h"
#import "IndexManager.h"
#import "NetworkUtil.h"
#import "GCDAsyncSocket.h"
#import "TcpUdpService.h"
#import "TCP_ResponseAnalysis.h"
#import "TcpData.h"
#import "OperatorResult.h"
#import "ProtocolData.h"
#import "UDPMethod.h"
#import "BoardCastAdress.h"
#import "UDP_ResponseAnalysis.h"
#import "TCPMethod.h"
#import "TcpUdpService.h"
#endif





/**
 *  敏识连接负载均衡服务器host,port
 */
#define AppBalanceHost      @"cloud.kangtai.com.cn"
#define AppBalancePort      29531//u
#define UdpBindPort         28530
#define DevicePort          28530

#define LAN_PUSH_CMD        0x0f

#define HeadNoHiddenTag     1
#define HiddenTag           2
#define HeadNoHiddenLen     9

//超时时间
#define UDPTimeout          10
#define TCPTimeout          30



#define TcpIsonline_Notification            @"TcpIsonline" //设备在线
#define Tcpsubscribetoevent_Notification    @"Tcpsubscribetoevent" //订阅事件

#define UpdateStatus_Notification           @"UpdateStatus"//设备在线，发送更新设备信息通知
#define GetDeviceStatus_Notification        @"GetDeviceStatus" //获取设备状态，这里是获取个数据就更新次状态。
#define AddDeviceViewToArray_Notification   @"AddDeviceViewToArray" //添加设备视图

//故障通知, 0xe1~0xe9表示故障
#define DeviceError_Notification             @"DeviceError"


//指令
#define findDeviceOrder          0x23
#define heartBeat                0x61


#define Mac_Key_data                        @"mac"//mac地址
#endif /* TCPUDPdefine_h */
