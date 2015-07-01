//
//  TRMetaDataTool.h
//  TRDeals
//
//  Created by tarena on 15-6-25.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMetaDataTool : NSObject

//返回分类数组
+ (NSArray *)categories;

/**
 *  返回344个城市
 */
+ (NSArray *)cities;


/**
 *  返回所有的排序数据
 */
+ (NSArray *)sorts;

//给定城市名字，返回该城市的区域数组
+ (NSArray *)regionByCityName:(NSString *)cityName;


+ (NSArray *)cityGroups;





@end
