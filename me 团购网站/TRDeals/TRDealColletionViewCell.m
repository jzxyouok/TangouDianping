//
//  TRDealColletionViewCell.m
//  TRDeals
//
//  Created by tarena on 15/6/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRDealColletionViewCell.h"
#import "UIImageView+WebCache.h"

@interface TRDealColletionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *priceNew;
@property (weak, nonatomic) IBOutlet UILabel *priceOld;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;
@end

@implementation TRDealColletionViewCell
//deal改变，连带改变，自动化
-(void)setDeal:(TRDeal *)deal{
    _deal = deal;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:deal.image_url ]];
    _title.text = deal.title;
    _desc.text = deal.desc;
    _priceNew.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
    _priceOld.text = [NSString stringWithFormat:@"￥%@", deal.list_price];
    _soldNum.text = [NSString stringWithFormat:@"已售:%d", deal.purchase_count];
}
@end
