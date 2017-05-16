//
//  CZQFriendThrendsViewController.m
//  BuDeJie
//
//  Created by 陈志强 on 16/11/21.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQFriendThrendsViewController.h"
#import "CZQRegisterAndLoginViewController.h"
#import "CZQFllowViewController.h"
#import <MJExtension.h>
#import "CZQFriendThrendsItem.h"
#import "CZQFriendThrendsCell.h"
#import "CZQFriendThrendsItem.h"

@interface CZQFriendThrendsViewController ()<UITableViewDelegate, UITableViewDataSource>

//记录登录成功与否状态
@property (nonatomic, assign, getter=isLoginSuccess) BOOL loginSuccess;
//记录登录成功后是否首次移除登录提示界面
@property (nonatomic, assign, getter=isFirstRemoveSubViews) BOOL firstRemoveSubViews;

//tabView
@property (nonatomic, weak) UITableView *myTab;

@property (nonatomic, strong) NSMutableArray *friendThrendsArr;


@property (nonatomic, assign, getter=isFirstAppear) BOOL firstAppear;//首次进入后值为真
@property (nonatomic, assign, getter=isAddFriendThrendsSuccess) BOOL addFriendThrendsSuccess;//添加客户成功

@end

@implementation CZQFriendThrendsViewController

static NSString * const FriendThrendsCellID = @"FriendThrendsCellID";

- (NSMutableArray *)friendThrendsArr {
//    if (!_friendThrendsArr) {
    
    if (self.isFirstAppear && self.isAddFriendThrendsSuccess) {//首次进入后+添加客户成功通知
        NSString *docPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"FriendThrends.plist"];
        NSArray *shaheArrM = [NSArray arrayWithContentsOfFile:filePath];
        [_friendThrendsArr removeAllObjects];
        _friendThrendsArr = [CZQFriendThrendsItem mj_objectArrayWithKeyValuesArray:shaheArrM];
        
    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstAddFT"]) {//沙河中已经存在了plist即不是app安装后首次启动
        NSString *docPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"FriendThrends.plist"];
        NSArray *shaheArrM = [NSArray arrayWithContentsOfFile:filePath];
        [_friendThrendsArr removeAllObjects];
        _friendThrendsArr = [CZQFriendThrendsItem mj_objectArrayWithKeyValuesArray:shaheArrM];
        
    }else {//首次进入
        _friendThrendsArr = [CZQFriendThrendsItem mj_objectArrayWithFilename:@"FriendThrends.plist"];
        self.firstAppear = YES;
    }
    
//    }
    
    return _friendThrendsArr;
}

#pragma mark - lazy
- (UITableView *)myTab{
    if (!_myTab) {
        CGRect tabFrame = CGRectMake(0, 64, CZQScreenWith, CZQScreenHight - CZQTabBarH - 64);
        UITableView *myTab = [[UITableView alloc] initWithFrame:tabFrame style:UITableViewStylePlain];
        myTab.backgroundColor = [UIColor clearColor];
        myTab.showsVerticalScrollIndicator = YES;
        myTab.showsHorizontalScrollIndicator = NO;
        //设置tableView的contentInset，使tableView全屏穿透效果并且能够展示首位所有内容并且不会弹回
        //顶部为基础20+44+TitleView的35 == 99  底部为tabBar的高度49
        myTab.contentInset = UIEdgeInsetsMake(-64, 0, -CZQTabBarH, 0);
        //*********设置滚动条的内边距
        myTab.scrollIndicatorInsets = myTab.contentInset;
        myTab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        myTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTab.delegate = self;
        myTab.dataSource = self;
        [self.view addSubview:myTab];
        _myTab = myTab;
    }
    return _myTab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    //设置导航条
    [self setUpNavBar];
    //添加通知
    [self addObersvers];
}

- (void)viewWillAppear:(BOOL)animated {
//    if (self.isFirstRemoveSubViews) return;
    
    
    if (self.isLoginSuccess) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        });
        [self.myTab registerClass:[CZQFriendThrendsCell class] forCellReuseIdentifier:FriendThrendsCellID];
        
        //添加新模型处理
        [self friendThrendsArr];
        [self.myTab reloadData];
        
        self.firstRemoveSubViews = YES;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendThrendsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CZQFriendThrendsCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendThrendsCellID];
    cell.item = self.friendThrendsArr[indexPath.row];
    return cell;
}

#pragma mark - privateMethod
//注册通知
- (void)addObersvers {
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LOGIN_SUCCESS" object:nil];
    //添加新客户成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFriendThrendsSuccess) name:@"ADD_FRIEND_THRENDS_SUCCESS" object:nil];
}
//移除通知
- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGINBTN_CLICK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADD_FRIEND_THRENDS_SUCCESS" object:nil];
}


//添加新客户成功
- (void)addFriendThrendsSuccess {
    self.addFriendThrendsSuccess = YES;
}

- (void)loginSuccess {
    self.loginSuccess = YES;
}

- (void)dealloc {
    [self removeObservers];
}

//监听登录按钮点击 modal效果
- (IBAction)reginAndLoginBtnClick {
    CZQRegisterAndLoginViewController *reginAndLoginVC = [[CZQRegisterAndLoginViewController alloc] init];
    //跳转至注册登录界面 modal效果
    [self presentViewController:reginAndLoginVC animated:YES completion:nil];
}


#pragma mark - 设置导航条
- (void)setUpNavBar{
    //左边按钮
    UIImage *leftNorImage = [UIImage imageNamed:@"friendsRecommentIcon"];
    UIImage *leftHighImage = [UIImage imageNamed:@"friendsRecommentIcon-click"];
    //调用UIBarButtonItem分类直接生成需要的buttonItem
    UIBarButtonItem *leftBtnItem = [UIBarButtonItem itemWithNorImage:leftNorImage highImage:leftHighImage target:self action:@selector(friendThrendsLeftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    //中间文字
    self.navigationItem.title = @"我的客户";
    
    
}

- (void)friendThrendsLeftBtnClick{
    NSLog(@"friendThrendsLeftBtnClick");
    //跳转至关注Follow控制器页面
    CZQFllowViewController *followVC = [[CZQFllowViewController alloc] init];
    NSLog(@"%@",self.navigationController);
    [self.navigationController pushViewController:followVC animated:YES];
}


@end
