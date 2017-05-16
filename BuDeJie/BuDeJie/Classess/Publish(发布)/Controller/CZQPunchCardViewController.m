//
//  CZQPunchCardViewController.m
//  BuDeJie
//
//  Created by 清风 on 2017/5/11.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQPunchCardViewController.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "CZQTimeUtil.h"

@interface CZQPunchCardViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) NSString *nowTime;

@property (nonatomic, strong) NSString *nowTimeHM;

@property (nonatomic, strong) NSString *localStr;


@end

@implementation CZQPunchCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    [self setupNav];
    //初始化界面
    [self setupSubViews];
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
    [contentTextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(CZQTabBarH + CZQStatusBarH);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(100);
    }];
    
    //时间label
    NSString *nowTime = [CZQTimeUtil timeWithYMD];
    self.nowTime = nowTime;
    NSString *nowTimeHM = [CZQTimeUtil timeWithHM];
    self.nowTimeHM = nowTimeHM;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLabel.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
    [self makRadius:timeLabel];
    timeLabel.numberOfLines = 0;
    timeLabel.text = [NSString stringWithFormat:@"    当前时间:%@ %@", nowTime, nowTimeHM];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentTextV.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(55);
    }];
    

    //地点
    NSString *localStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfLocationStr"];
    self.localStr = localStr;
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    locationLabel.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
    locationLabel.font = [UIFont systemFontOfSize:12];
    [self makRadius:locationLabel];
    locationLabel.numberOfLines = 0;
    locationLabel.text = [NSString stringWithFormat:@"    当前位置:%@", localStr];
    [self.view addSubview:locationLabel];
    self.locationLabel = locationLabel;
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
    self.title = @"每日打卡";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打卡" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    // 强制更新(能马上刷新现在的状态)
    [self.navigationController.navigationBar layoutIfNeeded];
}

#pragma mark - click
- (void)post {
    
    /**
     解决bug，每次点击都首先读取bundle中的plist导致再次添加数据时候被覆盖
     解决思路只有第一次点击才会读取bundle中的plist，之后点击发布全部直接读取沙盒中的plist
     */
    
    BOOL isFirstPublishCard = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstPublishCard"];
    
    //新的模型
    NSDictionary *NewItemDit = @{
                                 @"imageStr" : @"discount.png",
                                 @"locationStr" : self.localStr,
                                 @"timeStr" : self.nowTime,
                                 @"timeDownStr" : self.nowTimeHM
                                 };
    if (isFirstPublishCard) {//首次发布成功后之后发布进入该判断
        NSString *docPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"Voice.plist"];
        NSMutableArray *shaheArrM = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        [shaheArrM insertObject:NewItemDit atIndex:0];
        
        BOOL ww = [shaheArrM writeToFile:filePath atomically:YES];
        
        
    }else {//首次发布
        //获取bundle中的plist
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Voice.plist" ofType:nil];
        NSMutableArray *bundelArrM = [NSMutableArray arrayWithContentsOfFile:dataPath];
        
        [bundelArrM insertObject:NewItemDit atIndex:0];
        
        NSString *docPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"Voice.plist"];
        
        BOOL ww = [bundelArrM writeToFile:filePath atomically:YES];
        
        NSArray *shaheArrM = [NSArray arrayWithContentsOfFile:filePath];
        
    }
    
    
    //发布计划发布成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PUNCH_CZARD_SUCCESS" object:nil];
    
    //提示框提示
    [SVProgressHUD showSuccessWithStatus:@"打卡成功"];
    
    //添加首次发布成功标记
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstPublishCard"];
    
    //退出
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancel];
    });
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
