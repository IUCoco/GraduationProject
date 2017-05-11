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

@interface CZQFriendThrendsViewController ()

//记录登录成功与否状态
@property (nonatomic, assign, getter=isLoginSuccess) BOOL loginSuccess;
//记录登录成功后是否首次移除登录提示界面
@property (nonatomic, assign, getter=isFirstRemoveSubViews) BOOL firstRemoveSubViews;

@end

@implementation CZQFriendThrendsViewController

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
    if (self.isFirstRemoveSubViews) return;
    if (self.isLoginSuccess) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.firstRemoveSubViews = YES;
    }
}

#pragma mark - privateMethod
//注册通知
- (void)addObersvers {
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LOGIN_SUCCESS" object:nil];
}
//移除通知
- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGINBTN_CLICK" object:nil];
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
