//
//  TRNavLeftView.h
//  TRDeals
//
//  Created by tarena on 15-6-25.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRNavLeftView : UIView
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

//加载自定义的xib
+ (id)view;

//点击导航栏左边自定义的view
- (void)addTarget:(id)target action:(SEL)action;











@end
