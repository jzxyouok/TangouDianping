//
//  TRCity.m
//  Demo1-DPSDK
//
//  Created by Xiao on 15/6/16.
//  Copyright (c) 2015年 Xiao. All rights reserved.
//

#import "TRCity.h"

@implementation TRCity


+ (id)parseCityData:(NSDictionary *)dataDic {
    
    return [[self alloc] initWithDictionaryData:dataDic];
}

- (id)initWithDictionaryData:(NSDictionary *)dataDic {
    
    if (self = [super init]) {
        
        self.name       = dataDic[@"name"];
        self.pinYin     = dataDic[@"pinYin"];
        self.pinYinHead = dataDic[@"pinYinHead"];
        self.regions    = dataDic[@"regions"];
        
    }
    
    return self;
}

@end
