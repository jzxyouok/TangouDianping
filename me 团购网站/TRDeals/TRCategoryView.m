//
//  TRCategoryView.m
//  TRDeals
//
//  Created by tarena on 15-6-26.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRCategoryView.h"
#import "TRMetaDataTool.h"
#import "TRCategory.h"

@interface TRCategoryView() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *secondTableView;

@property (nonatomic, strong) NSArray *categoryArray;


@end

@implementation TRCategoryView

//使用懒加载对分类数组初始化
- (NSArray *)categoryArray {
    if (!_categoryArray) {
        self.categoryArray = [TRMetaDataTool categories];
    }
    
    return _categoryArray;
    
}

+ (id)view {
    return [[[NSBundle mainBundle] loadNibNamed:@"TRCategoryView" owner:nil options:nil] lastObject];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return self.categoryArray.count;
        //return 10;
    } else {
        
        //获取用户点击左边表视图的行
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        NSLog(@"用户点击左边行数：%ld", (long)selectedRow);
        
        //通过用户选中左边的行，来获取分类数组中对应的模型对象
        TRCategory *selectedCategory = self.categoryArray[selectedRow];
        //再获取对应的模型对象的子分类
        NSArray *subArray = selectedCategory.subcategories;
        return subArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *cellID = @"categoryCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//    }
    
    if (tableView == self.mainTableView) {
        static NSString *cellID = @"leftCell";
        UITableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!leftCell) {
            leftCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        //设置背景图片
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        leftCell.backgroundView = bg;
        
        //设置选中的背景
        UIImageView *selectedBG = [[UIImageView alloc] init];
        selectedBG.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        leftCell.selectedBackgroundView = selectedBG;
        
        
        //设置cell
        //获取当前行的category模型对象
        TRCategory *category = self.categoryArray[indexPath.row];
        leftCell.textLabel.text = category.name;
        
        //显示左边的图标
        if (category.small_icon != nil) {
            leftCell.imageView.image = [UIImage imageNamed:category.small_icon];
        }
        
        //显示左边点中后的高亮图标
        if (category.small_highlighted_icon != nil) {
            leftCell.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
        }
        
        //显示扩展的图标
        if (category.subcategories.count > 0) {
            leftCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
        } else {
            leftCell.accessoryView = nil;
        }
        
        return leftCell;

    } else {
        static NSString *cellID = @"rightCell";
        UITableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!rightCell) {
            rightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        //设置背景图片
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_rightpart"];
        rightCell.backgroundView = bg;
        
        //设置选中的背景
        UIImageView *selectedBG = [[UIImageView alloc] init];
        selectedBG.image = [UIImage imageNamed:@"bg_dropdown_right_selected"];
        rightCell.selectedBackgroundView = selectedBG;
        
        int selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoryArray[selectedRow];
        //获取子分类
        NSArray *subArray = category.subcategories;
        rightCell.textLabel.text = subArray[indexPath.row];
        
        return rightCell;

        
    }
    
    return nil;
    
}

#pragma mark --- delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //刷新右边表视图
        [self.secondTableView reloadData];
        TRCategory *categorySel = self.categoryArray[indexPath.row];
        if (categorySel.subcategories.count == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TRCategoryDidChange" object:nil userInfo:@{@"TRSelectedCategory":categorySel,@"SelectedSubCategory":@""}];
        }
    }else{
        //发送通知
        NSInteger indexLeft = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger indexRight = indexPath.row;
        TRCategory *category = self.categoryArray[indexLeft];
        NSString *strNameSubCategory = category.subcategories[indexRight];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TRCategoryDidChange" object:nil userInfo:@{@"TRSelectedCategory":category,@"SelectedSubCategory":strNameSubCategory}];
    }
}



@end
