//
//  HJFloginVC.m
//  HJFkongtai
//
//  Created by 胡江峰 on 16/5/13.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "HJFloginVC.h"
#import "HJFForgetVC.h"
#import "HJFNavigationVC.h"
#import "HJFdeviceVC.h"

@interface HJFloginVC ()<UITextFieldDelegate>
@property (nonatomic ,weak) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat scrollMove;
@property (nonatomic,assign) CGFloat keyboardH;
@property (nonatomic ,weak) UITextField *accoutField;
@property (nonatomic ,weak) UITextField *passWordField;
@property (nonatomic ,weak) UIButton *registBtn;
@property (nonatomic ,weak) UIButton *logBtn;
@property (nonatomic,copy) NSString* accoutText;
@property (nonatomic,copy) NSString* passWordText;
@end

@implementation HJFloginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight]; //底色
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative ];//菊花类型
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//蒙板类型
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    
////    测试
//    _accoutText = @"654321@qq.com";
//    _passWordText =@"111111";
    
    
//    正式
    _accoutText = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_StoreageUSERNAME];
    _passWordText = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_StoreageUSERPASSWORD];
    
  
//    初始化UI
    [self UILayout];
    
//    添加触摸事件
    [self addGesture];
    
//    键盘弹出事件监控
    [self addKeyboardWillShowNotification];
}

//初始化ui
-(void)UILayout{
    CGFloat W =(ScreenW/320)*30;
    
    self.view.backgroundColor = RGBA(255, 254, 253, 1);
    
//    添加scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.x = 0;
    scrollView.y = 20;
    scrollView.width = ScreenW;
    scrollView.height = ScreenH-20;
    scrollView.contentSize = CGSizeMake(ScreenW, ScreenH-20);
    scrollView.showsVerticalScrollIndicator = NO;
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
//    添加背景
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_back_2"]];
    bgImage.x = 0;
    bgImage.y = -20;
    bgImage.width = ScreenW;
    bgImage.height = ScreenH;
    [self.scrollView addSubview:bgImage];
    
//    logo图片
    UIImageView *logImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"company_logo_2"]];
    logImage.width = 131;//262
    logImage.height = 51;//104
    logImage.centerX = ScreenW*0.5;
    logImage.y = 50;
    [bgImage addSubview:logImage];
    
//    textField图片
    UIImageView *textField = [[UIImageView alloc] init];
    textField.image = [UIImage imageNamed:@"login_input_squre"];
    textField.width = ScreenW - 2*W;
    textField.height= 220*textField.width/620;
    textField.x = W;
    textField.y = logImage.y+logImage.height+10;
    [self.scrollView addSubview:textField];
    
//  accoutField
    UITextField *accoutField = [[UITextField alloc] init];
    accoutField.width = textField.width-10;
    accoutField.height = textField.height*0.5;
    accoutField.x = textField.x+10 ;
    accoutField.y = textField.y ;
    accoutField.returnKeyType = UIReturnKeyNext;
    accoutField.placeholder = @"邮箱";
    accoutField.borderStyle = UITextBorderStyleNone;
    accoutField.keyboardType = UIKeyboardTypeEmailAddress;
    accoutField.delegate = self;
    accoutField.text = _accoutText;
    _accoutField = accoutField;
    [self.scrollView addSubview:accoutField];
    
//    passWordField
    UITextField *passWordField = [[UITextField alloc] init];
    passWordField.width = textField.width-10;
    passWordField.height = textField.height*0.5;
    passWordField.x = textField.x+10 ;
    passWordField.y = textField.y+accoutField.height;
    passWordField.returnKeyType = UIReturnKeyDone;
    passWordField.placeholder = @"密码";
    passWordField.borderStyle = UITextBorderStyleNone;
    passWordField.secureTextEntry = YES;
    passWordField.delegate = self;
    passWordField.text = _passWordText;
    _passWordField = passWordField;
    [self.scrollView addSubview:passWordField];
    
//    logBtn
    UIButton *logBtn = [[UIButton alloc] init];
    [logBtn setBackgroundImage:[UIImage imageNamed:@"login_button_normal"] forState:UIControlStateNormal];
    [logBtn setBackgroundImage:[UIImage imageNamed:@"login_button_click"] forState:UIControlStateSelected];
    [logBtn setTitle:@"登录" forState:UIControlStateNormal];
    _logBtn = logBtn;
    logBtn.width = textField.width;
    logBtn.height = 34;
    logBtn.x = textField.x ;
    logBtn.y = textField.y+textField.height+25;
    [logBtn addTarget:self action:@selector(logBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:logBtn];
    
//    registBtn
    UIButton *registBtn = [[UIButton alloc] init];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"sign_up_button_normal_2"] forState:UIControlStateNormal];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"sign_up_button_click_2"] forState:UIControlStateSelected];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.width = textField.width;
    registBtn.height = 34;
    registBtn.x = textField.x ;
    registBtn.y = logBtn.y+logBtn.height+25;
    _registBtn = registBtn;
    [self.scrollView addSubview:registBtn];
    
//   forgetBtn
    UIButton *forgetBtn = [[UIButton alloc] init];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [forgetBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    CGSize size = [comMethod titleSizeWithTitle:forgetBtn.titleLabel.text size:15];
    forgetBtn.width = size.width;
    forgetBtn.height = size.height;
    forgetBtn.x = ScreenW - W -forgetBtn.width;
    forgetBtn.y = ScreenH - forgetBtn.height-W-30;
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:forgetBtn];
}

//登录按钮
-(void)logBtnClick{

    NSString *acountText = _accoutField.text;
    NSString *passWordText = _passWordField.text;
    if ([comMethod JudgeUserName:acountText userPassword:passWordText]) {
        if (!IS_AVAILABLE_EMAIL(acountText)) {
            [comMethod showAlertWithTitle:nil msg:@"请输入正确邮箱"];
            return;
        }
        if (passWordText.length<6) {
            [comMethod showAlertWithTitle:nil msg:@"密码不能小于6位"];
        }
        _logBtn.enabled= NO;
        [self endEditing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginServerWithUserName:acountText passWord:passWordText];
        });
        
    }
    else{
        [comMethod showAlertWithTitle:nil msg:@"帐号或密码不能为空"];
    }
}

//忘记密码
-(void)forgetBtnClick{
    HJFForgetVC *VC = [[HJFForgetVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    self.navigationController.navigationBarHidden = NO;

}

//添加触摸结束
-(void)addGesture{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_scrollView addGestureRecognizer:tap];

}

-(void)tap{
    [self endEditing];

}

-(void)endEditing{
    [self.view endEditing:YES];
//    if (kScreen_Height+_scrollMove>loginViewScrollViewContentSize) {
//        [UIView animateWithDuration:0.5 animations:^{
//            _scrollMove = loginViewScrollViewContentSize-kScreen_Height;
//            _scrollView.contentOffset= CGPointMake(0, _scrollMove);
//        }];
//    }
    if (_logBtn.isEnabled ==NO) {
        _scrollView.contentOffset= CGPointMake(0,-20);
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset= CGPointMake(0,-20);
        }];
    }
    
    
}

//键盘弹出通知
-(void)addKeyboardWillShowNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
    name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    _keyboardH = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat btnH= CGRectGetMaxY(_registBtn.frame);
        CGFloat moveH = btnH+_keyboardH-ScreenH +20 ;
        NSLog(@"moveH=%f",moveH);
        if ((moveH>0)&&(moveH>_scrollMove)) {
            _scrollMove = moveH;
            _scrollView.contentOffset = CGPointMake(0, _scrollMove);
        }
        
        NSLog(@"_scrollMove=%f",_scrollMove);
        CGPoint point = _scrollView.contentOffset;
        NSLog(@"point.y=%f",point.y);
         NSLog(@"point.y=%f",point.y);
    }];
}

//textField开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   

}

//textField结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollMove=0;
        _scrollView.contentOffset = CGPointMake(0, _scrollMove);
    }];
}

//return键
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_accoutField) {
        [_passWordField becomeFirstResponder];
    }
    else{
        [self.view endEditing:YES];
    }
    return  YES;
}

/*****************************网络相关部分***************************/
//登录
- (void)loginServerWithUserName:(NSString *)userName passWord:(NSString *)passWord{
    [SVProgressHUD showWithStatus:@"登录中"];
    [HTTPServiceInstance loginServerWithUserName:userName passWord:passWord deviceToken:nil success:^(NSDictionary *dic) {
//        HJFLog(@"dic=%@,userName=%@,passWord=%@",dic,userName,passWord);
        if ([dic[@"success"] integerValue]) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:KEY_StoreageUSERNAME];
            [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:KEY_StoreageUSERPASSWORD];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self performSelector:@selector(pushDeviceView) withObject:nil afterDelay:1.1];
            [self pushDeviceView];
            [self getWifiListWithuserName:userName password:passWord];
            
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    } errorresult:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];

}

//获取wifi设备列表
- (void)getWifiListWithuserName:(NSString * )userName password:(NSString *)password{
    [HTTPServiceInstance getWifiListWithuserName:userName password:password success:^(NSDictionary *dic) {
        
        if ([dic[@"success"] integerValue]) {
            HJFHTTPLog(@"wifi设备列表获取成功，dic ＝ %@",dic);
            NSArray *deviceList = [dic objectForKey:@"list"];
            for (NSDictionary *deviceDic in deviceList) {
                DevicePreF * deviceAllinfo = [[DevicePreF alloc] init];
                deviceAllinfo.authCode = [deviceDic objectForKey:KEY_authCode];
                deviceAllinfo.companyCode = [deviceDic objectForKey:KEY_companyCode];
                deviceAllinfo.deviceName = [deviceDic objectForKey:KEY_deviceName];
                deviceAllinfo.deviceType = [deviceDic objectForKey:KEY_deviceType];
                deviceAllinfo.imageName = [deviceDic objectForKey:KEY_imageName];
                deviceAllinfo.lastOperation = [deviceDic objectForKey:KEY_lastOperation];
                deviceAllinfo.macAddress = [deviceDic objectForKey:KEY_macAddress];
                deviceAllinfo.orderNumber = [[deviceDic objectForKey:KEY_orderNumber] intValue];
                BOOL isExistsInAllInfo = [DeviceManageInstance IsExistsWithmacstr:deviceAllinfo.macAddress];
                if (!isExistsInAllInfo) {
                    //添加到设备单例
                    [DeviceManageInstance.device_array addObject:deviceAllinfo];
                }
                [DeviceManageInstance convertDeviceinfo:deviceAllinfo];
                
            }
        }
        [TCPMethodInstance JudgeConnect];
        //UDP绑定
//        [UDPMethodInstance udpBindConnect];
////发送局域网发现设备命令,判断设备单例中所有设备,udp是否在线
//        [UDPMethodInstance JugeAllDeviceudpOnline];
    } errorresult:^(NSError *error) {
         HJFLog(@"获取列表失败");
    }];
    


}

-(void)pushDeviceView{
    HJFdeviceVC *deviceView = [[HJFdeviceVC alloc] init];
    HJFNavigationVC *nav = [[HJFNavigationVC alloc] initWithRootViewController:deviceView];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = nav;
}



-(void)dealloc{
    HJFLog(@"LoginVC销毁了");
   }

@end
