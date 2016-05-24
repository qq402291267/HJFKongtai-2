//
//  UIBarButtonItem+tool.h
//  江峰小微
//
//  Created by 胡江峰 on 15/11/6.
//  Copyright © 2015年 胡江峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (tool)
+(UIBarButtonItem*)itemWithTarget:(id)target action:(SEL)action image:(NSString*)image highImage:(NSString*)highImage;
@end
