//
//  TRCityGroup.m
//  TRDeals
//
//  Created by tarena on 15/6/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRCityGroup.h"

@implementation TRCityGroup
+ (id)parseCityGroupData:(NSDictionary*)dataDic{
    return [[self alloc]initWithCityGroupData:dataDic];
}

- (id)initWithCityGroupData:(NSDictionary*)dataDic{
    if (self = [super init]) {
        self.title = dataDic[@"title"];
        self.cities = dataDic[@"cities"];
    }
    return self;
}
@end
