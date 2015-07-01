//
//  TRSort.m
//  Demo1-DPSDK
//
//  Created by Xiao on 15/6/16.
//  Copyright (c) 2015年 Xiao. All rights reserved.
//

#import "TRSort.h"

@implementation TRSort

+ (id)parseSortData:(NSDictionary *)dataDic {
    
    return [[self alloc] initWithDictionaryData:dataDic];
}

- (id)initWithDictionaryData:(NSDictionary *)dataDic {
    
    if (self = [super init]) {
        
        self.label = dataDic[@"label"];
        self.value = [dataDic[@"value"] intValue];
 
    }
    
    return self;
}

@end
