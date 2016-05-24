//
//  HJFtableView.h
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/20.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DevicePreF;
@interface HJFtableView : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic ,weak) DevicePreF *deviceInfo;

@end
