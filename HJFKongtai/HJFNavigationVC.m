//
//  HJFNavigationVC.m
//  HJFkongtai
//
//  Created by 胡江峰 on 16/5/14.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "HJFNavigationVC.h"

@interface HJFNavigationVC ()

@end

@implementation HJFNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

// 第一次使用这个类或者这个类的子类的时候
+ (void)initialize
{
    if (self == [HJFNavigationVC class]) { // 肯定能保证只调用一次
        
        [self setupNav];
        
    }
}

+ (void)setupNav
{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageWithColor:RGBA(120, 192, 31, 1)] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:20]
                           };
    [bar setTitleTextAttributes:dict];
 
    // 设置导航条的主题颜色
    //    [bar setTintColor:[UIColor greenColor]];//返回按钮的颜色
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
