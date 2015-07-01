//
//  TRDealsCollectionViewController.m
//  TRDeals
//
//  Created by tarena on 15-6-25.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRDealsCollectionViewController.h"
#import "TRNavLeftView.h"
#import "TRCategoryViewController.h"
#import "TRRegionsViewController.h"
#import "TRSortsViewController.h"

//三个监听模型
#import "TRCategory.h"
#import "TRCity.h"
#import "TRSort.h"
#import "TRRegion.h"

//view
#import "TRDealColletionViewCell.h"

#import "DPAPI.h"

#import "TRDeal.h"

//第三方库
#import "UIScrollView+BottomRefreshControl.h"

#import "TRDetailDealVC.h"


@interface TRDealsCollectionViewController () <DPRequestDelegate>

//创建"分类"弹出控制器
@property (nonatomic, strong) UIPopoverController *categoryPopController;
// 区域Popover控制器
@property (strong, nonatomic) UIPopoverController *regionPopover;
// 排序Popover控制器
@property (strong, nonatomic) UIPopoverController *sortPopover;


//“分类”view
@property (nonatomic, strong) TRNavLeftView *categoryView;
// 区域视图
@property (weak, nonatomic) TRNavLeftView *regionCityView;
// 排序视图
@property (weak, nonatomic) TRNavLeftView *sortView;




//点评API相关属性
@property (strong, nonatomic) DPAPI *api;
@property (strong, nonatomic) DPRequest *request;


//接受监听相关属性
@property (assign, nonatomic) NSInteger selectedSortValue;//sort
@property (strong, nonatomic) NSString *selectedCategoryName;//category
@property (strong, nonatomic) NSString *selectedSubCategoryName;//subcategory
@property (strong, nonatomic) NSString *selectedRegionName;//区域
@property (strong, nonatomic) NSString *selectedCityName;//城市
@property (strong, nonatomic) NSArray *arrDeals;//
@property (strong, nonatomic) NSMutableArray *arrMDeals;//


//发送请求的params
@property (assign, nonatomic) NSInteger currentPage;
@end




@implementation TRDealsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


#pragma mark --- 懒加载方式初始化
//懒加载方式初始化categoryPopController
- (UIPopoverController *)categoryPopController {
    
    if (_categoryPopController == nil) {
        TRCategoryViewController *categoryViewController = [[TRCategoryViewController alloc] init];
 
        self.categoryPopController = [[UIPopoverController alloc] initWithContentViewController:categoryViewController];
    }
    
    return _categoryPopController;
    
}

-(DPAPI *)api{
    if (!_api) {
        _api = [DPAPI new];
    }
    return _api;
}

- (NSMutableArray*)arrMDeals{
    if (!_arrMDeals) {
        _arrMDeals = [NSMutableArray array];
    }
    return _arrMDeals;
}


#pragma mark --- 区域的Popover控制器
// 区域Popover控制器
- (UIPopoverController *)regionPopover
{
    if (!_regionPopover) {

        TRRegionsViewController *regionViewController = [[TRRegionsViewController alloc] init];
        self.regionPopover = [[UIPopoverController alloc] initWithContentViewController:regionViewController];
    }
    return _regionPopover;
}


// 排序Popover控制器
- (UIPopoverController *)sortPopover
{
    if (!_sortPopover) {
        TRSortsViewController *sortsViewController = [[TRSortsViewController alloc] init];
        self.sortPopover = [[UIPopoverController alloc] initWithContentViewController:sortsViewController];
    }
    return _sortPopover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    //监听事件
    [self setUpListenEvent];
    
    //创建右边items
    [self setupRightItems];
    
    //创建左边items
    [self setupLeftItems];
    
    //创建刷新控件
    [self setUpFreshControl];
}


#pragma mark --- 上拉刷新
- (void)setUpFreshControl{
    UIRefreshControl *refreshCtr = [UIRefreshControl new];
    refreshCtr.triggerVerticalOffset = 100;//偏移量
    refreshCtr.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在等待加载更多团购订单..."];
    
    [refreshCtr addTarget:self action:@selector(loadMoreDeals) forControlEvents:UIControlEventAllEvents];
    
    //设置collectionView的bottom control属性
    self.collectionView.bottomRefreshControl = refreshCtr;
}



#pragma mark --- 监听事件
- (void)setUpListenEvent{
    //四个监听
    
    //监听区域改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionDidChange:) name:@"TRRegionDidChange" object:nil];
    
    // 监听城市改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:@"TRCityDidChange" object:nil];
    
    
    // 监听排序改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidChange:) name:@"TRSortDidChange" object:nil];
    
    //category监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeCategory:) name:@"TRCategoryDidChange" object:nil];
}

- (void)regionDidChange:(NSNotification*)notification{
    TRRegion *region = notification.userInfo[@"TRSelectedRegion"];
    //应该去subRegion
    if ([region.name isEqualToString:@"全部"]) {
        //更换顶部排序item的文字
        self.selectedRegionName = nil;
        self.regionCityView.titleLabel.text = [NSString stringWithFormat:@"%@", self.selectedCityName];
        self.regionCityView.subTitleLabel.text = @"全部";
        [self.regionPopover dismissPopoverAnimated:YES];
        [self reloadNewDeals];
    }else{//发送
        if (region.subregions.count != 0) {
            self.selectedRegionName = notification.userInfo[@"TRSelectedSubRegion"];
        }else{
            self.selectedRegionName = region.name;
        }
        
        if ([self.selectedRegionName isEqualToString:@"全部"]) {
            //应该是可以选择全部的
            self.selectedRegionName = region.name;
            //更换顶部排序item的文字
            self.regionCityView.titleLabel.text = [NSString stringWithFormat:@"%@", self.selectedCityName];
            self.regionCityView.subTitleLabel.text = self.selectedRegionName;
        }else{
            //更换顶部排序item的文字
            self.regionCityView.titleLabel.text = [NSString stringWithFormat:@"%@ %@", self.selectedCityName,region.name];
            self.regionCityView.subTitleLabel.text = self.selectedRegionName;
        }

        [self.regionPopover dismissPopoverAnimated:YES];
        [self reloadNewDeals];
        
    }

}

- (void)cityDidChange:(NSNotification*)notification{
    self.selectedCityName = notification.userInfo[@"TRSelectedCityName"];
    
    //更换顶部排序item的文字
    self.regionCityView.titleLabel.text = self.selectedCityName;
    //self.regionCityView.subTitleLabel.text = self.selectedRegionName;
    self.regionCityView.subTitleLabel.text = nil;

    //[self.regionPopover dismissPopoverAnimated:YES];
    [self reloadNewDeals];
}

- (void)sortDidChange:(NSNotification*)notification{
    TRSort *selectedSort = notification.userInfo[@"TRSelectedSort"];
    
    //更换顶部排序item的文字
    self.sortView.titleLabel.text = selectedSort.label;
    self.sortView.subTitleLabel.text = @"www排序";
    
    self.selectedSortValue = selectedSort.value;
    
    [self.sortPopover dismissPopoverAnimated:YES];
    [self reloadNewDeals];
}

- (void)didChangeCategory:(NSNotification*)notification{
    TRCategory *selectedCategory = notification.userInfo[@"TRSelectedCategory"];
    self.selectedSubCategoryName = notification.userInfo[@"SelectedSubCategory"];
    self.selectedCategoryName = selectedCategory.name;

    
    //点击小图标改变
    [self.categoryView.navButton setImage:[UIImage imageNamed:selectedCategory.small_icon] forState:UIControlStateNormal];
    [self.categoryView.navButton setImage:[UIImage imageNamed:selectedCategory.small_highlighted_icon] forState:UIControlStateHighlighted];
    
    
    if ([selectedCategory.name isEqualToString:@"全部分类"]) {
        //
    }else{
        //显示顶部分类文本
        self.categoryView.titleLabel.text = selectedCategory.name;
        self.categoryView.subTitleLabel.text = self.selectedSubCategoryName;
        
        if (![self.selectedSubCategoryName isEqualToString:@"全部"] && self.selectedSubCategoryName.length != 0){
            self.selectedCategoryName = self.selectedSubCategoryName;
        }
        
        [self.categoryPopController dismissPopoverAnimated:YES];
        [self reloadNewDeals];
    }
}

#pragma mark --- 发送请求更新Deals界面
//加载订单的逻辑
- (void)loadMoreDeals{
    //page++
    self.currentPage ++;
    [self sendData];
}

- (void)reloadNewDeals{
    self.currentPage = 1;
    [self sendData];
}

- (void)sendData{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    // 城市
    //城市是必须的参数--------*******必须有
    if (self.selectedCityName) {
        params[@"city"] = self.selectedCityName;
    } else{
        params[@"city"] = @"南京";
    }
    // 分类(类别)
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }else{
        params[@"category"] = @"美食";
    }
    // 区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }else{
        //params[@"region"] = @"雨花台区";
        
    }
    // 排序
    if (self.selectedSortValue) {
        // int ---> NSNumber
        params[@"sort"] = @(self.selectedSortValue) ;
    }
    
    // 可以不设置：：：设置单次返回的数量(为了显示数量小)
    //params[@"limit"] = @(6);
    
    params[@"page"] = [NSString stringWithFormat:@"%ld",(long)self.currentPage];
    
    
    //打印发送参数
    NSLog(@"发送请求参数为：%@", params.allValues);
    
    //params[@"city"] = @"南京";
    //params[@"category"] = self.selectedCategoryName;
    //params[@"sort"] = @(self.selectedSortValue);
    self.request = [self.api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    [self.request connect];
}

#pragma mark --- 创建右边items
- (void)setupRightItems {
    
    
    UIButton *mapButton = [[UIButton alloc] init];
    //设置mapButton
    //背景图片
//    [mapButton setBackgroundImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
    [mapButton setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
    [mapButton setImage:[UIImage imageNamed:@"icon_map_highlighted"] forState:UIControlStateHighlighted];
    [mapButton addTarget:self action:@selector(clickMap) forControlEvents:UIControlEventTouchUpInside];
    //frame
    mapButton.frame = CGRectMake(0, 0, 60, 40);
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
    //for test
    //mapButton.backgroundColor = [UIColor redColor];
    
    //作业：封装
    UIButton *searchButton = [[UIButton alloc] init];
    //设置searchButton
    //背景图片
//    [searchButton setBackgroundImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"icon_search_highlighted"] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    //frame
    searchButton.frame = CGRectMake(0, 0, 60, 40);
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    //for test
    //searchButton.backgroundColor = [UIColor blueColor];
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
    
}

#pragma mark --- 创建左边items
- (void)setupLeftItems {
    
    //加载logo图片
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    //加载三个自定义的view
    //加载分类
    self.categoryView = [TRNavLeftView view];
    self.categoryView.titleLabel.text = @"全部";//默认是美食
    self.categoryView.subTitleLabel.text = @"";//默认是
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:self.categoryView];
    [self.categoryView addTarget:self action:@selector(clickCategoryView)];
    
    //加载区域／城市
    self.regionCityView = [TRNavLeftView view];
    self.regionCityView.titleLabel.text = @"南京";//默认是南京
    self.regionCityView.subTitleLabel.text = @"全部";//默认是南京
    UIBarButtonItem *regionCityItem = [[UIBarButtonItem alloc] initWithCustomView:self.regionCityView];
    [self.regionCityView addTarget:self action:@selector(clickRegionView)];
    
    //加载排序
    self.sortView = [TRNavLeftView view];
    self.sortView.titleLabel.text = @"默认排序";//默认是南京
    self.sortView.subTitleLabel.text = @"排序";//默认是南京
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:self.sortView];
    [self.sortView addTarget:self action:@selector(clickSortView)];

    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionCityItem, sortItem];
    
}

#pragma mark --- 点击弹出pop控制器
- (void)clickCategoryView {
    [self.categoryPopController presentPopoverFromRect:self.categoryView.bounds inView:self.categoryView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)clickRegionView {
    
    [self.regionPopover presentPopoverFromRect:self.regionCityView.bounds inView:self.regionCityView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


- (void)clickSortView {
    
    [self.sortPopover presentPopoverFromRect:self.sortView.bounds inView:self.sortView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

#pragma mark --- 按钮响应事件
- (void)clickMap {
    
}

- (void)clickSearch {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 点评API Delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"发送失败！");
    //取消加载更多动画
    [self.collectionView.bottomRefreshControl endRefreshing];

}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    NSLog(@"发送成功！结果是：%@",result);
    self.arrDeals = [self parseDealWithResult:result];
    [self.arrMDeals addObjectsFromArray:self.arrMDeals];
    
    if (self.currentPage == 1) {
        [self.arrMDeals removeAllObjects];
        [self.arrMDeals addObjectsFromArray:self.arrDeals];
    }else {
        [self.arrMDeals addObjectsFromArray:self.arrDeals];
    }
    
    [self.collectionView reloadData];
    
    //取消加载更多动画
    [self.collectionView.bottomRefreshControl endRefreshing];

}

- (NSArray*)parseDealWithResult:(id)result{
    NSArray *arr = result[@"deals"];
    NSMutableArray *arrMDeals = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        TRDeal *deal = [TRDeal parseDealWithDictionary:dic];
        [arrMDeals addObject:deal];
    }
    return [arrMDeals copy];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.arrMDeals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRDealColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"deal" forIndexPath:indexPath];
    // Configure the cell
    cell.deal = self.arrMDeals[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

//新开一个VC，显示详细内容
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //1,创建一个自定义的
    TRDetailDealVC *detailVC = [TRDetailDealVC new];
    detailVC.deal = self.arrMDeals[indexPath.row];
    [detailVC hidesBottomBarWhenPushed];
    //2,推出
    [self presentViewController:detailVC animated:YES completion:nil];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/



@end
