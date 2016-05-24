//
//  ForgetVC.m
//  HJFkongtai
//
//  Created by 胡江峰 on 16/5/14.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "UIBarButtonItem+CH.h"
#import "HJFForgetVC.h"

@interface HJFForgetVC ()

@end

@implementation HJFForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"return_normal" highIcon:@"return_normal_click" target:self action:@selector(leftBtnClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithRightIcon: @"confirm_normal_2" highIcon:@"confirm_click_2" target:self action:@selector(rightBtnClick)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden =YES;

}

-(void)rightBtnClick{

}

@end
