//
//  TRDeal.h
//  TRDeals
//
//  Created by tarena on 15-6-25.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRDeal : NSObject

// 团购单ID  
@property (copy, nonatomic) NSString *deal_id;
// 团购标题  
@property (copy, nonatomic) NSString *title;
// 团购描述
//和description的关键词有冲突
@property (copy, nonatomic) NSString *desc;
// 团购包含商品原价值  
@property (strong, nonatomic) NSNumber *list_price;
// 团购价格  
@property (strong, nonatomic) NSNumber *current_price;
// 团购当前已购买数  
@property (assign, nonatomic) int purchase_count;
// 团购图片链接，最大图片尺寸450×280  
@property (copy, nonatomic) NSString *image_url;
// 小尺寸团购图片链接，最大图片尺寸160×100  
@property (copy, nonatomic) NSString *s_image_url;
// string	团购发布上线日期  
@property (nonatomic, copy) NSString *publish_date;

// url属性的问题
@property (nonatomic, strong) NSString *deal_h5_url;


+ (id)parseDealWithDictionary:(NSDictionary *)dealDic;












@end
