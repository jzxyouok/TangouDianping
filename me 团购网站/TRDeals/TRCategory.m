//
//  TRCategory.m
//  TRDeals
//
//  Created by tarena on 15-6-25.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRCategory.h"

@implementation TRCategory

+ (id)parseCategoryData:(NSDictionary *)dataDic {
    

    return [[self alloc] initWithDictionaryData:dataDic];
}

- (id)initWithDictionaryData:(NSDictionary *)dataDic {
    
    if (self = [super init]) {
        
        self.name          = dataDic[@"name"];
        self.subcategories = dataDic[@"subcategories"];
        
        self.small_highlighted_icon = dataDic[@"small_highlighted_icon"];
        self.highlighted_icon       = dataDic[@"highlighted_icon"];
        
        self.small_icon = dataDic[@"small_icon"];
        self.icon       = dataDic[@"icon"];
        self.map_icon   = dataDic[@"map_icon"];
    }
    
    return self;
}

@end
