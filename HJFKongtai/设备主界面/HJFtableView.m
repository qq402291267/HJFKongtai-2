//
//  HJFtableView.m
//  HJFKongtai
//
//  Created by 胡江峰 on 16/5/20.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "HJFtableView.h"
#import "UIImage+CH.h"
#import "on_offBtn.h"
@interface HJFtableView()
@property (nonatomic ,weak) UIButton *deviceImageBtn;//设备图片
@property (nonatomic ,weak) UILabel *deviceNameLable;//
@property (nonatomic ,weak) UILabel *offlineLable;//
@property (nonatomic ,weak) on_offBtn *online_btn;//
@property (nonatomic ,weak) UILabel *downLine;//
@property (nonatomic ,weak) UIImageView *loadingView;//转菊花
@property (nonatomic,assign) BOOL viewLoaded;
@property (nonatomic,strong) NSTimer * animationTimer;

@end

@implementation HJFtableView
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"status";
    // 1.缓存中取
   HJFtableView *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
       
        cell = [[HJFtableView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        设备头像
        UIButton *deviceImageBtn= [[UIButton alloc] init];
        _deviceImageBtn = deviceImageBtn;
        [self addSubview:deviceImageBtn];
        
//        设备名称
        UILabel *deviceNameLable = [[UILabel alloc] init];
        deviceNameLable.font = [UIFont systemFontOfSize:18];
        deviceNameLable.backgroundColor = [UIColor clearColor];
        deviceNameLable.textAlignment = NSTextAlignmentLeft;
        _deviceNameLable = deviceNameLable;
        [self addSubview:deviceNameLable];
        
        
//        离线lab
        UILabel *offlineLable = [[UILabel alloc] init];
        offlineLable.font = [UIFont systemFontOfSize:15];
        offlineLable.textColor = [UIColor blackColor];
        offlineLable.textAlignment = NSTextAlignmentCenter;
        offlineLable.backgroundColor = RGBA(250, 250, 250, 1);
        _offlineLable = offlineLable;
        [self addSubview:offlineLable];
        
//        在线按钮
        on_offBtn *online_btn = [[on_offBtn alloc] init];
        online_btn.backgroundColor = RGBA(250, 250, 250, 1);
        [online_btn addTarget:self action:@selector(openCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _online_btn = online_btn;
        [self addSubview:online_btn];
        
//        分割线
        UILabel *downLine = [[UILabel alloc] init];
        downLine.backgroundColor = RGBA(241, 241, 241, 1);
        _downLine = downLine;
        [self addSubview:downLine];
        
        //loadingview
        UIImageView *loadingView = [[UIImageView alloc] init];
        loadingView.image = [UIImage imageNamed:@"power_waiting_circle"];
        loadingView.hidden = YES;
        _loadingView = loadingView;
        //因为要改变形状，不能在layoutSubviews里设置
        loadingView.hidden  =YES;
        [self addSubview:loadingView];

    }
    return self;
}

-(void)setDeviceInfo:(DevicePreF *)deviceInfo{

    _deviceInfo =deviceInfo;
    [self setDeviceData];
    [self layoutSubviews];

}
-(void)setDeviceData{
//    设备图片
    UIImage *grayImage = [UIImage grayImage:[UIImage imageNamed:_deviceInfo.imageName]];
    UIImage *grayNewImage = [UIImage clipWithImage:grayImage bordersW:0 borderColor:nil];
    UIImage *newImage = [UIImage clipWithImageName:_deviceInfo.imageName bordersW:0 borderColor:[UIColor redColor]];
    [_deviceImageBtn setImage:grayNewImage forState:UIControlStateNormal];
    [_deviceImageBtn setImage:newImage forState:UIControlStateSelected];

//    设备名称
    _deviceNameLable.text = _deviceInfo.deviceName;
    
//    开关按键
    if (_deviceInfo.deviceOn) {
        [_online_btn setImage:[UIImage imageNamed:@"power_on"] forState:UIControlStateNormal];
    }
    else{
        [_online_btn setImage:[UIImage imageNamed:@"power_off"] forState:UIControlStateNormal];
    }
    _online_btn.hidden = !(_deviceInfo.remoteIsOnline ||_deviceInfo.localIsOnline);
    
//    设备状态
    _offlineLable.text = @"离线";
    _offlineLable.hidden = _deviceInfo.remoteIsOnline ||_deviceInfo.localIsOnline;
//    _on_off_btn



}

-(void)layoutSubviews{
    _deviceImageBtn.width = 60;
    _deviceImageBtn.height = _deviceImageBtn.width;
    _deviceImageBtn.x = 10;
    _deviceImageBtn.centerY = self.centerY;
    
    _deviceNameLable.height = 50;
    _deviceNameLable.width = 160;
    _deviceNameLable.x = CGRectGetMaxX(_deviceImageBtn.frame)+15;
    _deviceNameLable.centerY = _deviceImageBtn.centerY;
    

    _online_btn.width = self.height;
    _online_btn.height = self.height;
    _online_btn.y= 0;
    _online_btn.x = self.width-_online_btn.width;
//    [self insertSubview:_online_btn atIndex:0];
   
    
    _offlineLable.width = self.height;
    _offlineLable.height = self.height-1;
    _offlineLable.x= self.width-_online_btn.width;
    _offlineLable.y = 0;
//    [self insertSubview:_offlineLable atIndex:0];
    

    _downLine.width = self.width;
    _downLine.height = 1;
    _downLine.x =0;
    _downLine.y =self.height -1;
    
    if (!_viewLoaded) {
        _viewLoaded = YES;
        _loadingView.width =46;
        _loadingView.height =46;
        _loadingView.centerX =ScreenW - 40;
        _loadingView.centerY =40;
    }

}



-(void)openCloseBtnClick:(UIButton *)btn{
    [self startAnimation];
    UInt8 type = 0x00;
//    BOOL tempMainOpen = !_deviceInfo.deviceOn;
    UInt8 status = _deviceInfo.deviceOn ? 0x00 :0xff;
    DevicePreF *deviceInfo = [DeviceManageInstance getDevicePreFWithmac:_deviceInfo.macdata];
    
    NSData *sendData = [ProtocolData setDeviceIOStatus:NewIndex controlType:type controlStatus:status deviceinfo:deviceInfo isremote:!deviceInfo.localIsOnline];
    [TcpUdpServiceInstance sendData:sendData deviceinfo:deviceInfo complete:^(OperatorResult *resultData) {
        if (resultData) {
            NSDictionary * resultdict = resultData.responsedictionary;
            BOOL issuccessful = [[resultdict objectForKey:KEY_Result_B] boolValue];
            NSLog(@"设置完成:issuccessful = %d",issuccessful);
            if (issuccessful) {
//                deviceInfo.deviceOn = tempMainOpen;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //主界面中侦测，发送通知,更新设备状态
                    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateStatus_Notification object:@{Mac_Key_data:deviceInfo.macdata}];
                });
            }
            
        } else {
            NSLog(@"设置失败,设置超时");
        }
        
        [self stopAnimation];
    }];

}

-(void)startAnimation{
    _online_btn.hidden = YES;
    _loadingView.hidden = NO;
//    _offlineLable.hidden = YES;
    NSTimer *animationTimer = [NSTimer timerWithTimeInterval:0.15 target:self selector:@selector(animate:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSRunLoopCommonModes];
}
- (void)animate:(NSTimer *)timer{
    _loadingView.transform = CGAffineTransformRotate(_loadingView.transform, RADIANS_TO_DEGREES(50));
}

- (void)stopAnimation;
{
    _online_btn.hidden = NO;
    _loadingView.hidden = YES;
    [_animationTimer invalidate];
    _animationTimer = nil;
}


@end
