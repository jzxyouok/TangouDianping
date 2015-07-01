//
//  TRCitiesVC.m
//  TRDeals
//
//  Created by tarena on 15/6/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
/*
    这里的TableView用Group用
 
 
 
*/

#import "TRCitiesVC.h"
#import "TRMetaDataTool.h"
#import "TRCityGroup.h"

@interface TRCitiesVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrCityGroups;
@end

@implementation TRCitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellCityGroup"];
    //self.arrCityGroups = [TRMetaDataTool cityGroups];
}

-(NSArray *)arrCityGroups{
    if (!_arrCityGroups) {
        _arrCityGroups = [TRMetaDataTool cityGroups];
    }
    return _arrCityGroups;
}

//点击取消
- (IBAction)clickCancle:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 这里是 TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{//Sections
    return self.arrCityGroups.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{//Rows
    TRCityGroup *citiGroup = self.arrCityGroups[section];
    return citiGroup.cities.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellCityGroup"];
    TRCityGroup *citiGroup = self.arrCityGroups[indexPath.section];
    cell.textLabel.text = citiGroup.cities[indexPath.row];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{//这里是Header
    TRCityGroup *citiGroup = self.arrCityGroups[section];
    return citiGroup.title;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // 将cityGroups数组中所有元素的title属性值取出来，放到一个新的数组
    return [self.arrCityGroups valueForKeyPath:@"title"];
}
//////第三步添加：用户点击城市某行，发送通知
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRCityGroup *group = self.arrCityGroups[indexPath.section];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCityDidChange" object:nil userInfo:@{@"TRSelectedCityName" : group.cities[indexPath.row]}];
    
    //弹回城市视图控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
