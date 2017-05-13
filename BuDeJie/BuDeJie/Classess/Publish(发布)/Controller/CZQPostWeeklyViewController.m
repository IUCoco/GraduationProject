//
//  CZQPostWeeklyViewController.m
//  BuDeJie
//
//  Created by 清风 on 2017/5/11.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQPostWeeklyViewController.h"
#import <Masonry.h>

@interface CZQPostWeeklyViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentTextV;

@end

@implementation CZQPostWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    [self setupNav];
    //初始化界面
    [self setupSubViews];
    [self.contentTextV becomeFirstResponder];
}

#pragma mark - 设置界面
- (void)setupSubViews {
//    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:self.view.frame];
//    bgImageV.image = [UIImage imageNamed:@"shareBottomBackground"];
//    [self.view addSubview:bgImageV];
    
    UIImageView *placeholderImageV = [[UIImageView alloc] initWithFrame:self.view.frame];
    placeholderImageV.image = [UIImage imageNamed:@"weekly"];
    [self.view addSubview:placeholderImageV];
    
    //周报详情
    UITextView *contentTextV = [[UITextView alloc] initWithFrame:CGRectZero];
    contentTextV.delegate = self;
    contentTextV.returnKeyType = UIReturnKeyDone;
    [self makRadius:contentTextV];
    [self.view addSubview:contentTextV];
    self.contentTextV = contentTextV;
    [contentTextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(CZQTabBarH + CZQStatusBarH);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(100);
    }];
    
    //时间label
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLabel.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
    [self makRadius:timeLabel];
    timeLabel.numberOfLines = 0;
    timeLabel.text = @"    本地时间:\n    2017-05-12 18:30";
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentTextV.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(55);
    }];
    
    //地点
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    locationLabel.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
    locationLabel.font = [UIFont systemFontOfSize:12];
    [self makRadius:locationLabel];
    locationLabel.numberOfLines = 0;
    locationLabel.text = @"    当前位置:\n    浙江杭州:\n    杭州电子科技大学";
    [self.view addSubview:locationLabel];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(55);
    }];
    
    //发报人信息
    UILabel *personalDetailsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    personalDetailsLabel.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
    personalDetailsLabel.font = [UIFont systemFontOfSize:12];
    [self makRadius:personalDetailsLabel];
    personalDetailsLabel.numberOfLines = 0;
    personalDetailsLabel.text = @"    员工号:13108410  部门:移动互联网事业部\n    姓名:陈志强\n    电话:15988413022";
    [self.view addSubview:personalDetailsLabel];
    [personalDetailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(locationLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(55);
    }];
    
}


//设置导航栏
- (void)setupNav
{
    self.title = @"每周日报";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 强制更新(能马上刷新现在的状态)
    [self.navigationController.navigationBar layoutIfNeeded];
}

#pragma mark - click
- (void)post
{
    //    XMGLogFunc;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - privateMethod
//设置圆角
- (void)makRadius:(UIView *) view {
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 1.0;
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds  =YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}



@end
