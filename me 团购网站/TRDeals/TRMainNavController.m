//
//  TRMainNavController.m
//  TRDeals
//
//  Created by tarena on 15-6-25.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRMainNavController.h"

@interface TRMainNavController ()

@end

@implementation TRMainNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加nav背景图片
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
}



@end
