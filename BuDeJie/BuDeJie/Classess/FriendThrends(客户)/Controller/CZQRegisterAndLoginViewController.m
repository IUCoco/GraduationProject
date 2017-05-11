//
//  CZQRegisterAndLoginViewController.m
//  BuDeJie
//
//  Created by 陈志强 on 16/11/27.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQRegisterAndLoginViewController.h"
#import "CZQLoginAndRegisteModelView.h"
#import "CZQFastLoginView.h"
#import "CZQLoginTextF.h"
#import <AVOSCloud.h>

@interface CZQRegisterAndLoginViewController ()
//中间View
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;
//底部View
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//登录View
@property (nonatomic, strong) CZQLoginAndRegisteModelView *loginView;
//注册View
@property (nonatomic, strong) CZQLoginAndRegisteModelView *registerView;


@end



@implementation CZQRegisterAndLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //登录View
    CZQLoginAndRegisteModelView *loginView = [CZQLoginAndRegisteModelView loginView];
    self.loginView = loginView;
    [self.middleView addSubview:loginView];
    //注册View
    CZQLoginAndRegisteModelView *registerView = [CZQLoginAndRegisteModelView registerView];
    self.registerView = registerView;
    [self.middleView addSubview:registerView];
    //快速登录View
    CZQFastLoginView *fastLoginView = [CZQFastLoginView fastLoginView];
    [self.bottomView addSubview:fastLoginView];
    
    //添加通知
    [self addObersvers];
    
}
/*-------- viewDidLayoutSubviews ---------**/
//布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //登录注册
    CZQLoginAndRegisteModelView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.czq_with * 0.5, self.middleView.czq_hight);
    CZQLoginAndRegisteModelView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.czq_with * 0.5, 0, self.middleView.czq_with * 0.5, self.middleView.czq_hight);
    //快速登录
    CZQFastLoginView *fastLoginView = self.bottomView.subviews[0];
    fastLoginView.frame = self.bottomView.bounds;
}


#pragma mark - click
//退出登录
- (IBAction)dismissBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击注册按钮
- (IBAction)registBtnClick:(UIButton *)registBtn {
    registBtn.selected = !registBtn.selected;
    //将middleView向右移动
    _leadingCons.constant = _leadingCons.constant == 0? - self.middleView.czq_with * 0.5:0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded]; 
    }];
}

//login
- (void)loginBtnClick {
    NSLog(@"%@+++++++", self.loginView.loginPhoneNum);
    NSLog(@"%@+++++++", self.loginView.loginPwd.text);
    NSString *username = self.loginView.loginPhoneNum.text;
    NSString *password = self.loginView.loginPwd.text;
    if (username && password) {
        // LeanCloud - 登录
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
            if (error) {
                NSLog(@"登录失败 %@", error);
            } else {
                NSLog(@"登录成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_SUCCESS" object:nil];
            }
        }];
    }
    
}

//register
- (void)registerBtnClick {
    NSLog(@"%@+++++++", self.registerView.registPhoneNum);
    NSLog(@"%@+++++++", self.registerView.registPwd);
}

#pragma mark - privateMethod
//注册通知
- (void)addObersvers {
    //登录按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginBtnClick) name:@"LOGINBTN_CLICK" object:nil];
    //注册按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerBtnClick) name:@"REGISTERBTN_CLICK" object:nil];
}
//移除通知
- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGINBTN_CLICK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REGISTERBTN_CLICK" object:nil];
}




- (void)dealloc {
    [self removeObservers];
}

@end
