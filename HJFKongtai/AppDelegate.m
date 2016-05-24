//
//  AppDelegate.m
//  HJFkongtai
//
//  Created by 胡江峰 on 16/5/13.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "AppDelegate.h"
#import "HJFloginVC.h"
#import "HJFNavigationVC.h"
@interface AppDelegate ()<NetworkUtilDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    HJFloginVC *tabVC =[[HJFloginVC alloc]init];
    HJFNavigationVC *nav = [[HJFNavigationVC alloc] initWithRootViewController:tabVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [NetworkUtilInstance setNetworkStatusDelegate:self];
 
    return YES;
}

//-----------
#pragma mark - 网络改变通知
-(void)networkStatusChanged:(ReachabilityNetworkStatus)status
{
    switch (status) {
        case ReachableViaWiFi:{
//            
//            [ ShowMMProgressHUDWithTitle:nil status:@"连接网络为WiFi,更新设备网络连接"];
//            //延时消失加载
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //消失加载
//                [MMProgressHUD dismiss];
//            });
//                        //Tcp连接,Udp连接
//                        [RemoteServiceInstance JudgeConnect];
//                        [LocalServiceInstance udpBindConnect];
//                        //发现所有已经添加设备
//                        [LocalServiceInstance JugeAllDeviceudpOnline];
            HJFUDPLog(@"网络为wifi。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。");
//            [SVProgressHUD showErrorWithStatus:@"wifi"];
            break;
        }
        case ReachableViaWWAN:{
//            [Util ShowMMProgressHUDWithTitle:nil status:@"连接网络为数据流量,更新设备网络连接"];
//            //延时消失加载
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //消失加载
//                [MMProgressHUD dismiss];
//            });
//            //Tcp连接
//            [RemoteServiceInstance JudgeConnect];
            HJFUDPLog(@"网络为3g。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。");
//            [SVProgressHUD showErrorWithStatus:@"3G"];
            break;
        }
        case NotReachable:{
//            [Util ShowMMProgressHUDWithTitle:nil status:@"连接网络断开,更新设备网络连接"];
//            //延时消失加载
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //消失加载
//                [MMProgressHUD dismiss];
//            });
//            //断开Tcp,Udp
//            [RemoteServiceInstance disconnect];
//            [LocalServiceInstance CloseUdpBind];
            HJFUDPLog(@"没网络。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。");
//            [SVProgressHUD showErrorWithStatus:@"NO"];
            break;
        }
        default:
            break;
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
