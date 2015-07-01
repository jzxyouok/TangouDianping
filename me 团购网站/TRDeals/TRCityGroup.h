//
//  TRCityGroup.h
//  TRDeals
//
//  Created by tarena on 15/6/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRCityGroup : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *cities;

+ (id)parseCityGroupData:(NSDictionary*)dataDic;
@end
