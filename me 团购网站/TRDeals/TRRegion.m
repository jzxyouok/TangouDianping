//
//  TRRegion.m
//  Demo1-DPSDK
//
//  Created by Xiao on 15/6/21.
//  Copyright (c) 2015年 Xiao. All rights reserved.
//

#import "TRRegion.h"

@implementation TRRegion


+ (id)parseRegionDataByCity:(NSDictionary *)dataDic {
    
    return [[self alloc] initWithDictionaryData:dataDic];
}

- (id)initWithDictionaryData:(NSDictionary *)dataDic {
    
    if (self = [super init]) {
        
        self.name = dataDic[@"name"];
        self.subregions = dataDic[@"subregions"];
    }
    
    return self;
}

@end
