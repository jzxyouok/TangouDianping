//
//  TRRegion.h
//  Demo1-DPSDK
//
//  Created by Xiao on 15/6/21.
//  Copyright (c) 2015年 Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRRegion : NSObject

/** 区域名称 */
@property (copy, nonatomic) NSString *name;
/** 子区域 */
@property (strong, nonatomic) NSArray *subregions;

//根据某个城市，返回该城市的所有区域
+ (id)parseRegionDataByCity:(NSDictionary *)dataDic;

@end
