//
//  TRRegionsViewController.m
//  TRDeals
//
//  Created by tarena on 15-6-26.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRRegionsViewController.h"
#import "TRMetaDataTool.h"
#import "TRRegion.h"
#import "TRCitiesVC.h"

@interface TRRegionsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *secondTableView;

//声明区域属性
@property (nonatomic, strong)NSArray *regionArray;

@end

@implementation TRRegionsViewController

//初始化区域数组
- (NSArray *)regionArray {
    if (!_regionArray) {
#warning TODO: hard code: beijing
        _regionArray = [TRMetaDataTool regionByCityName:@"南京"];//默认城市
    }
    
    return _regionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.preferredContentSize = CGSizeMake(300, 480);
    
    // 监听城市改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:@"TRCityDidChange" object:nil];
    
    //////修改视图小的问题
    //self.preferredContentSize = CGSizeMake(400, 480);
}





#pragma mark --- 监听城市变化
- (void)cityDidChange: (NSNotification *)notification {
//    
//    //获取通知中的城市名字参数
//    NSString *selectedCityName = notification.userInfo[@"TRSelectedCityName"];
//    
//    // 1. 修改regions数据
//    self.regionArray = [TRMetaDataTool regionByCityName:selectedCityName];
//    
//    // 2.刷新表格数据
//    [self.mainTableView reloadData];
//    [self.secondTableView reloadData];
    
    NSString *strGetCityName = notification.userInfo[@"TRSelectedCityName"];
    self.regionArray = [TRMetaDataTool regionByCityName:strGetCityName];
    [self.mainTableView reloadData];
    [self.secondTableView reloadData];
}

#pragma mark -- dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        return self.regionArray.count;
        //return 10;
    } else {
        // 获取leftTableView选中的行
        int selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        
        NSLog(@"当前选中第几行：%d", selectedRow);
        TRRegion *region = self.regionArray[selectedRow];
        NSArray *subRegionArray = region.subregions;
        NSLog(@"当前有几个子区域：%lu", (unsigned long)subRegionArray.count);
        return subRegionArray.count;
        //return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.mainTableView) {
        static NSString *ID = @"left";
        UITableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!leftCell) {
            leftCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        leftCell.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        leftCell.selectedBackgroundView = selectedBg;
        
        //获取当前选中行对应的TRCategory模型对象
        TRRegion *region = self.regionArray[indexPath.row];
        // 显示标题
        leftCell.textLabel.text = region.name;
        
        // 处理右边的箭头，如果有子区域的话
        if (region.subregions.count > 0) {
            leftCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
        } else {
            leftCell.accessoryView = nil;
        }
        
        return leftCell;
        
    } else {
        
        static NSString *ID = @"right";
        UITableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!rightCell) {
            rightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        //设置cell的背景图片和点击之后的背景图片
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_rightpart"];
        rightCell.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_right_selected"];
        rightCell.selectedBackgroundView = selectedBg;
        
        //// 得到leftTableView 选中的行
        int leftRow = [self.mainTableView indexPathForSelectedRow].row;
        
        TRRegion *region = self.regionArray[leftRow];
        
        //获取当前category分类的自分类
        NSArray *array = region.subregions;
        rightCell.textLabel.text = array[indexPath.row];
        
        return rightCell;
    }
    //return cell;
}


#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        // 刷新右边视图
        TRRegion *region = self.regionArray[indexPath.row];
        //如果右边没有
        if (region.subregions.count == 0) {
            //发送
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TRRegionDidChange" object:nil userInfo:@{@"TRSelectedRegion":region,@"TRSelectedSubRegion":@""}];
        }else{
            [self.secondTableView reloadData];
        }
        
    } else {

        //////监听分类添加方法
        int selectLeftRow = [self.mainTableView indexPathForSelectedRow].row;
        int selectRightRow = [self.secondTableView indexPathForSelectedRow].row;
        
        ///////获取分区域模型对象
        TRRegion *region = self.regionArray[selectLeftRow];
        //////获取子区域对象
        NSString *subRegion = region.subregions[selectRightRow];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:nil userInfo:@{@"TRSelectedRegion" : region, @"TRSelectedSubRegion" :subRegion}];
    }
}

//切换
- (IBAction)buttonClickPopCItyGroups:(UIButton *)sender {
    TRCitiesVC *citiesViewController = [TRCitiesVC new];
    /*
     
     UIModalPresentationFullScreen = 0,
     UIModalPresentationPageSheet NS_ENUM_AVAILABLE_IOS(3_2),
     UIModalPresentationFormSheet NS_ENUM_AVAILABLE_IOS(3_2),
     UIModalPresentationCurrentContext NS_ENUM_AVAILABLE_IOS(3_2),
     UIModalPresentationCustom NS_ENUM_AVAILABLE_IOS(7_0),
     UIModalPresentationOverFullScreen NS_ENUM_AVAILABLE_IOS(8_0),
     UIModalPresentationOverCurrentContext NS_ENUM_AVAILABLE_IOS(8_0),
     UIModalPresentationPopover NS_ENUM_AVAILABLE_IOS(8_0),
     UIModalPresentationNone NS_ENUM_AVAILABLE_IOS(7_0) = -1,
     
     
     */
    citiesViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:citiesViewController animated:YES completion:nil];
}


@end
