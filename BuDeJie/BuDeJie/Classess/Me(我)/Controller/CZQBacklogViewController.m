//
//  CZQBacklogViewController.m
//  BuDeJie
//
//  Created by 清风 on 2017/5/13.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQBacklogViewController.h"
#import "CZQBacklogCell.h"
#import <MJExtension.h>
#import "CZQBacklogItem.h"

static NSString *ID = @"backlogCell";

@interface CZQBacklogViewController ()

@property (nonatomic, strong) NSMutableArray *backlogArr;

@end

@implementation CZQBacklogViewController

- (NSMutableArray *)backlogArr {
    if (!_backlogArr) {
        _backlogArr = [CZQBacklogItem mj_objectArrayWithFilename:@"Backlog.plist"];
    }
    return _backlogArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[CZQBacklogCell class] forCellReuseIdentifier:ID];
    //设置导航栏
    [self setupNav];
    
}

//设置导航栏
- (void)setupNav
{
    self.title = @"待办事项";
    // 强制更新(能马上刷新现在的状态)
    [self.navigationController.navigationBar layoutIfNeeded];
}


#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.backlogArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZQBacklogCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.item = self.backlogArr[indexPath.row];
    return cell;
    
}

@end
