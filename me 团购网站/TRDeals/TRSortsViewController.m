//
//  TRSortsViewController.m
//  TRDeals
//
//  Created by tarena on 15-6-26.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRSortsViewController.h"
#import "TRMetaDataTool.h"
#import "TRSort.h"

@interface TRSortsViewController ()

@end

@implementation TRSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取排序对象数组
    NSArray *sortsArray = [TRMetaDataTool sorts];
    //获取按钮的个数
    int count = sortsArray.count;
    
    //定义常量
    //按钮高度和宽度
    CGFloat buttonHeight = 30;
    CGFloat buttonWidth = 100;
    //按钮距离左边和上边的间距
    CGFloat buttonX = 15;
    CGFloat buttonY = 15;
    //按钮上下之间的间距
    CGFloat buttonMargin = 15;
    
    int height = 0;
    
    for (int i = 0; i < count; i++) {
        // 第i个sort模型对象
        TRSort *sort = sortsArray[i];
        
        
        UIButton *button = [[UIButton alloc] init];
        //大小
        button.frame = CGRectMake(buttonX, buttonY + i * (buttonHeight + buttonMargin), buttonWidth, buttonHeight);
        //设置button的文本
        [button setTitle:sort.label forState:UIControlStateNormal];
        
        //设置按钮显示文本的颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        //设置背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        
        button.tag = i;

        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        //设置height
        height = CGRectGetMaxY(button.frame);
    }
    
    self.preferredContentSize = CGSizeMake((buttonWidth + 2 * buttonX), height + buttonMargin);
    
    
    
    
}

- (void)clickButton:(UIButton *)button {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRSortDidChange" object:nil userInfo:@{@"TRSelectedSort" : [TRMetaDataTool sorts][button.tag]}];
}



@end
