//
//  BoardCastAdress.h
//  Minshi
//
//  Created by 胡江峰 on 16/1/9.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BoardCastAdressInstance [BoardCastAdress shareBoardCastAdress]



@interface BoardCastAdress : NSObject



+ (BoardCastAdress *)shareBoardCastAdress;

/**
 *  更新广播地址
 *  局域网监听时更新
 */
- (void)updateBroadCastAddress;

//获取当前广播地址
- (NSString *)getcurrentBroadCastAddress;

@end
