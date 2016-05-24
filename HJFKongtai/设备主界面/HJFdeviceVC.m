//
//  HJFdeviceVC.m
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/20.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "HJFdeviceVC.h"
#import "UIBarButtonItem+CH.h"
#import "HJFtableView.h"
#import "SVProgressHUD.h"
@interface HJFdeviceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UITableView *deviceTableView;


@end

@implementation HJFdeviceVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIinit];
    [self addNotification];
    [SVProgressHUD showWithStatus:@"加载中...."];
   
}

-(void)UIinit{
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"wifi设备";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"list_menu_normal" highIcon:@"list_menu_click" target:self action:@selector(leftBtnClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithRightIcon: @"add_normal" highIcon:@"add_click" target:self action:@selector(rightBtnClick)];
    
//    UITableView初始化
    UITableView *deviceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    deviceTableView.rowHeight= 80;
    deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    deviceTableView.delegate =self;
    deviceTableView.dataSource = self;
    self.deviceTableView = deviceTableView;
    [self.view addSubview:self.deviceTableView];

}

//通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateDeviceStatus:) name:UpdateStatus_Notification object:nil];

}

//刷新状态通知
- (void)UpdateDeviceStatus:(NSNotification *)notification{
    [self setDevice_array:DeviceManageInstance.device_array];
    [SVProgressHUD dismiss];
    
}

//刷新状态代码
-(void)setDevice_array:(NSMutableArray *)device_array{
    _device_array = device_array;
    [_deviceTableView reloadData];
}


-(void)leftBtnClick{
    
}

-(void)rightBtnClick{
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _device_array.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HJFtableView *cell = [HJFtableView cellWithTableView:tableView];
    cell.deviceInfo = _device_array[indexPath.row];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
