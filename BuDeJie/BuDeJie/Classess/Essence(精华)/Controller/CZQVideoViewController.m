//
//  CZQVideoViewController.m
//  BuDeJie
//
//  Created by 陈志强 on 16/12/2.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQVideoViewController.h"
#import "CZQVideoItem.h"
#import <MJExtension.h>
#import "CZQVideoCell.h"

@interface CZQVideoViewController ()

@property (nonatomic, strong) NSMutableArray *videoArrM;

@property (nonatomic, assign, getter=isFirstAppear) BOOL firstAppear;//首次进入后值为真

@property (nonatomic, assign, getter=isFakenBackSuccess) BOOL takenBackSuccess;

@end

@implementation CZQVideoViewController

static NSString *ID = @"VideoCell";

- (NSMutableArray *)videoArrM {
//    if (!_videoArrM) {
    if (self.isFirstAppear && self.isFakenBackSuccess) {//首次进入后+发布计划成功通知
        NSString *docPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"Video.plist"];
        NSArray *shaheArrM = [NSArray arrayWithContentsOfFile:filePath];
        [_videoArrM removeAllObjects];
        _videoArrM = [CZQVideoItem mj_objectArrayWithKeyValuesArray:shaheArrM];

    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstPublishTB"]) {//沙河中已经存在了plist即不是app安装后首次启动
        NSString *docPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"Video.plist"];
        NSArray *shaheArrM = [NSArray arrayWithContentsOfFile:filePath];
        [_videoArrM removeAllObjects];
        _videoArrM = [CZQVideoItem mj_objectArrayWithKeyValuesArray:shaheArrM];
        
    }else {//首次进入
        _videoArrM = [CZQVideoItem mj_objectArrayWithFilename:@"Video.plist"];
        self.firstAppear = YES;
    }
    
//    }
    return _videoArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObersvers];
    //设置tableView的contentInset，使tableView全屏穿透效果并且能够展示首位所有内容并且不会弹回
    //顶部为基础20+44+TitleView的35 == 99  底部为tabBar的高度49
    self.tableView.contentInset = UIEdgeInsetsMake(CZQTitleViewH, 0, CZQTabBarH + CZQContentInsetH, 0);
    //*********设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //********添加监听CZQTabBarButtonDidRepeatClickNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:CZQTabBarButtonDidRepeatClickNotification object:nil];
    //**********添加监听CZQTitleButtonDidRepeatClickNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:CZQTitleButtonDidRepeatClickNotification object:nil];
    
    [self.tableView registerClass:[CZQVideoCell class] forCellReuseIdentifier:ID];
}

- (void)viewWillAppear:(BOOL)animated {
    [self videoArrM];
    [self.tableView reloadData];
}

//**********监听事件CZQTabBarButtonDidRepeatClickNotification
- (void)tabBarButtonDidRepeatClick{
    //如果重复点击的按钮不是精华按钮则返回，不刷新 ,*****************因为点击其他按钮的时候当前控制器会被暂时移除keyWindow
    if (self.view.window == nil) return;
    //如果精华页面显示的不是当前控制器的View返回，不刷新, **********因为如果精华当前显示的控制器view为当前控制器的view，只有当前控制器的view的scrollsToTop为YES
    if (self.tableView.scrollsToTop == NO) return;
    //排除上面两种可能后才能判断当前点击了精华按钮，并且显示的是当前控制器的View
    NSLog(@"CZQVideoViewController监听了CZQTabBarButtonDidRepeatClickNotification点击------执行刷新");
}

//***********监听事件CZQTitleButtonDidRepeatClickNotification
- (void)titleButtonDidRepeatClick{
    //如果重复点击的按钮不是精华按钮则返回，不刷新 ,*****************因为点击其他按钮的时候当前控制器会被暂时移除keyWindow
    if (self.view.window == nil) return;
    //如果精华页面显示的不是当前控制器的View返回，不刷新, **********因为如果精华当前显示的控制器view为当前控制器的view，只有当前控制器的view的scrollsToTop为YES
    if (self.tableView.scrollsToTop == NO) return;
    //排除上面两种可能后才能判断当前点击了精华按钮，并且显示的是当前控制器的View
    NSLog(@"CZQVideoViewController监听了CZQTitleButtonDidRepeatClickNotification点击------执行刷新");
}


#pragma mark - privateMethod
//注册通知
- (void)addObersvers {
    //发布周报成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tanekBackSuccess) name:@"TAKEN_BACK_SUCCESS" object:nil];
}

//移除监听
- (void)dealloc{
    //移除CZQAllViewController的监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//发布周报成功
- (void)tanekBackSuccess {
    self.takenBackSuccess = YES;
}


#pragma mark - 数据源

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZQVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.item = self.videoArrM[indexPath.row];
    return cell;
    
}

@end
