//
//  TRSort.h
//  Demo1-DPSDK
//
//  Created by Xiao on 15/6/16.
//  Copyright (c) 2015年 Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRSort : NSObject

/** 排序名称 */
@property (nonatomic, copy) NSString *label;
/** 排序的值(将来发给服务器) */
@property (nonatomic, assign) int value;


+ (id)parseSortData:(NSDictionary *)dataDic;

@end
