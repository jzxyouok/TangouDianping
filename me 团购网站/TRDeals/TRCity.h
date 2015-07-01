//
//  TRCity.h
//  Demo1-DPSDK
//
//  Created by Xiao on 15/6/16.
//  Copyright (c) 2015年 Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRCity : NSObject

/** 城市名字 */
@property (nonatomic, copy) NSString *name;
/** 城市名字的拼音 */
@property (nonatomic, copy) NSString *pinYin;
/** 城市名字的拼音声母 */
@property (nonatomic, copy) NSString *pinYinHead;
/** 区域(存放的都是MTRegion模型) */
@property (nonatomic, strong) NSArray *regions;

+ (id)parseCityData:(NSDictionary *)dataDic;

@end
