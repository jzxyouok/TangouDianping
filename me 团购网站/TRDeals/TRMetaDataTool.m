//
//  TRMetaDataTool.m
//  TRDeals
//
//  Created by tarena on 15-6-25.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRMetaDataTool.h"
#import "TRCategory.h"
#import "TRCity.h"
#import "TRRegion.h"
#import "TRSort.h"
#import "TRCityGroup.h"

@implementation TRMetaDataTool

#pragma mark -- cityGroups
static NSArray *_cityGroups = nil;
+ (NSArray *)cityGroups{
    if (!_cityGroups) {
        _cityGroups = [[self alloc] getAndParseCityGroupFile:@"cityGroups.plist"];
    }
    return _cityGroups;
}

- (NSArray*)getAndParseCityGroupFile:(NSString*)cityGroupFile{
    NSArray *arr = [self getArrayFromPlistFile:cityGroupFile];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dicHere in arr) {
        TRCityGroup *cityGroup = [TRCityGroup parseCityGroupData:dicHere];
        [arrM addObject:cityGroup];
    }
    
    return [arrM copy];
}

- (NSArray *)getArrayFromPlistFile:(NSString *)fileName {
    //从bundle中获取文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
    
    return [dataArray copy];
    
}

//线程不安全
static NSArray *_categories = nil;
+ (NSArray *)categories {
    
    if (_categories == nil) {
        _categories = [[self alloc]getAndParseCategoryFile:@"categories.plist"];
    }
    
    return _categories;
}

- (NSArray *)getAndParseCategoryFile:(NSString *)fileName {
    
    //获取plist路径
    NSString *categoryFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    //读取plist文件的内容
    NSArray * dataArray = [NSArray arrayWithContentsOfFile:categoryFilePath];
    
    //解析
    NSMutableArray *mutArray = [NSMutableArray new];
    
    for (NSDictionary *categoryDic in dataArray) {
//#warning 使用NSObject方法直接从对象转模型
        TRCategory *category = [TRCategory new];
        [category setValuesForKeysWithDictionary:categoryDic];
        
//        TRCategory *category = [TRCategory parseCategoryData:categoryDic];
        [mutArray addObject:category];
    }
    
    return [mutArray copy];
}

#pragma mark --- 城市相关方法
static NSArray *_cities = nil;
+ (NSArray *)cities {
    if (_cities == nil) {
        //读取categories.plist文件; 并解析存储到_categories数组中
        _cities = [[self alloc] getAndParseCityFile:@"cities.plist"];
        //NSLog(@"城市数组 %@", _cities);
    }
    return _cities;
    
}

- (NSArray *)getAndParseCityFile:(NSString *)fileName {
    
    NSArray *dataArray = [self getArrayFromPlistFile:fileName];
    
    NSMutableArray *dataMutableArray = [NSMutableArray new];
    
    for (NSDictionary *dataDic in dataArray) {
        
        TRCity *city = [TRCity parseCityData:dataDic];
        [dataMutableArray addObject:city];
        
    }
    
    return [dataMutableArray copy];
}

#pragma mark --- 区域相关方法

//返回某个城市的所有区域
+ (NSArray *)regionByCityName:(NSString *)cityName {
    //1. 通过城市的数组citiesArray，获取城市名字为cityName的那个城市模型对象
    
    //2. 通过上面for循环找到的城市模型，获取该城市的区域数组

    //如果传入的城市名字长度为空
    if (cityName.length == 0) {
        return nil;
    }
    
    //从cities中寻找我们需要的城市模型对象
    TRCity *findCity = nil;
    for (TRCity *city in self.cities) {
        //如果当前城市的名字和传入的城市名字一样，表明找到了
        if ([city.name isEqualToString:cityName]) {
            findCity = city;
        }
    }
    
    //return findCity.regions;
    
    
    //dataArray中的NSDictionary对象 ---> TRRegion模型类
    //声明一个可变数组
    NSMutableArray *dataMutableArray = [NSMutableArray new];

    for (NSDictionary *regionDic in findCity.regions) {
        
        TRRegion *region = [TRRegion parseRegionDataByCity:regionDic];
        [dataMutableArray addObject:region];
        
    }
    
    return [dataMutableArray copy];
    
}

#pragma mark --- 排序相关方法
static NSArray *_sorts = nil;
+ (NSArray *)sorts {
    if (_sorts == nil) {
        //读取categories.plist文件; 并解析存储到_categories数组中
        _sorts = [[self alloc] getAndParseSortFile:@"sorts.plist"];
        NSLog(@"排序数组 %@", _sorts);
    }
    return _sorts;
    
}

- (NSArray *)getAndParseSortFile:(NSString *)fileName {
    
    NSArray *dataArray = [self getArrayFromPlistFile:fileName];
    
    //dataArray中的NSDictionary对象 ---> TRSort模型类
    //声明一个可变数组
    NSMutableArray *dataMutableArray = [NSMutableArray new];
    
    for (NSDictionary *dataDic in dataArray) {
        
        TRSort *sort = [TRSort parseSortData:dataDic];
        [dataMutableArray addObject:sort];
        
    }
    
    return [dataMutableArray copy];
}

@end
