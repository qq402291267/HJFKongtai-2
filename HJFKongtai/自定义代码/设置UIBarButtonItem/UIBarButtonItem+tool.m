//
//  UIBarButtonItem+tool.m
//  江峰小微
//
//  Created by 胡江峰 on 15/11/6.
//  Copyright © 2015年 胡江峰. All rights reserved.
//

#import "UIBarButtonItem+tool.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (tool)
+(UIBarButtonItem*)itemWithTarget:(id)target action:(SEL)action image:(NSString*)image highImage:(NSString*)highImage
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置图片
    [Btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [Btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    
    // 设置尺寸
    Btn.size = Btn.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc] initWithCustomView:Btn];

}
@end
