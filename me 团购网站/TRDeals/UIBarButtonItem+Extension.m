//
//  UIBarButtonItem+Extension.m
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    //设置按钮填充模式
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //button.backgroundColor = [UIColor redColor];
    
    ///// 后添加50 ---> 100(扩大两个按钮之间的距离)
    button.frame = CGRectMake(0, 0, 60, 40);
    
    // 设置按钮的尺寸为背景图片的尺寸(更加通用, 可选)
//    CGRect frame = button.frame;
//    frame.size = button.currentImage.size;
//    button.frame = frame;
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
