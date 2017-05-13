//
//  CZQWordViewController.m
//  BuDeJie
//
//  Created by 陈志强 on 16/12/2.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQWordViewController.h"
#import <Masonry.h>

@interface CZQWordViewController ()

@end

@implementation CZQWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableView的contentInset，使tableView全屏穿透效果并且能够展示首位所有内容并且不会弹回
    //顶部为基础20+44+TitleView的35 == 99  底部为tabBar的高度49
    self.tableView.contentInset = UIEdgeInsetsMake(CZQTitleViewH, 0, CZQTabBarH + CZQContentInsetH, 0);
    //*********设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //********添加监听CZQTabBarButtonDidRepeatClickNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:CZQTabBarButtonDidRepeatClickNotification object:nil];
    //**********添加监听CZQTitleButtonDidRepeatClickNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:CZQTitleButtonDidRepeatClickNotification object:nil];
    [self setupCompanyInfoView];
}

//**********监听事件CZQTabBarButtonDidRepeatClickNotification
- (void)tabBarButtonDidRepeatClick{
    //如果重复点击的按钮不是精华按钮则返回，不刷新 ,*****************因为点击其他按钮的时候当前控制器会被暂时移除keyWindow
    if (self.view.window == nil) return;
    //如果精华页面显示的不是当前控制器的View返回，不刷新, **********因为如果精华当前显示的控制器view为当前控制器的view，只有当前控制器的view的scrollsToTop为YES
    if (self.tableView.scrollsToTop == NO) return;
    //排除上面两种可能后才能判断当前点击了精华按钮，并且显示的是当前控制器的View
    NSLog(@"CZQWordViewController监听了CZQTabBarButtonDidRepeatClickNotification点击------执行刷新");
}

//***********监听事件CZQTitleButtonDidRepeatClickNotification
- (void)titleButtonDidRepeatClick{
    //如果重复点击的按钮不是精华按钮则返回，不刷新 ,*****************因为点击其他按钮的时候当前控制器会被暂时移除keyWindow
    if (self.view.window == nil) return;
    //如果精华页面显示的不是当前控制器的View返回，不刷新, **********因为如果精华当前显示的控制器view为当前控制器的view，只有当前控制器的view的scrollsToTop为YES
    if (self.tableView.scrollsToTop == NO) return;
    //排除上面两种可能后才能判断当前点击了精华按钮，并且显示的是当前控制器的View
    NSLog(@"CZQWordViewController监听了CZQTitleButtonDidRepeatClickNotification点击------执行刷新");
}

//移除监听
- (void)dealloc{
    //移除CZQAllViewController的监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 公司信息

- (void)setupCompanyInfoView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tableView.frame];
    bgView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = bgView;
    
    UILabel *companyNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    companyNameLabel.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
    companyNameLabel.numberOfLines = 0;
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.font = [UIFont boldSystemFontOfSize:20];
    companyNameLabel.text = @"杭州电子科技大学";
    [bgView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(30);
        make.left.equalTo(bgView.mas_left).offset(30);
        make.right.equalTo(bgView.mas_right).offset(-30);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *companyInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    companyInfoLabel.font = [UIFont systemFontOfSize:12];
    companyInfoLabel.numberOfLines = 0;
    companyInfoLabel.text = @"        杭州电子科技大学（Hangzhou Dianzi University），简称杭电，是浙江省人民政府与国防科技工业局共建的教学研究型大学，是浙江省首批重点建设的5所高校之一。\n        学校前身为创建于1956年的杭州航空工业财经学校，是中国较早成立的一所以信息科技（IT）学科为主导的高等院校，先后隶属于机械工业部、电子工业部和信息产业部等中央部委，1980年经国务院批准设立杭州电子工业学院，2004年更名为杭州电子科技大学\n        截止2017年5月，学校建有下沙、文一、东岳、下沙东及信息工程学院临安新校区共五个校区，占地面积2500余亩。学校拥有本科教育、研究生教育、继续教育、留学生教育等完整的人才培养体系，设有20个学院及教学单位，有本科专业58个，普通全日制在校生28000余人，教职员工2300余人。并举办一所独立学院——杭州电子科技大学信息工程学院";
    [bgView addSubview:companyInfoLabel];
    [companyInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyNameLabel.mas_bottom).offset(30);
        make.left.equalTo(bgView.mas_left).offset(30);
        make.right.equalTo(bgView.mas_right).offset(-30);
    }];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    copyrightLabel.numberOfLines = 0;
    copyrightLabel.font = [UIFont systemFontOfSize:10];
    copyrightLabel.text = @"Copyright© 2010 杭州电子科技大学版权所有 All right reserved";
    [bgView addSubview:copyrightLabel];
    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(30);
        make.bottom.equalTo(bgView.mas_bottom).offset(-30-CZQTabBarH-CZQContentInsetH);
        make.right.equalTo(bgView.mas_right).offset(-30);
    }];
}

#if 0
#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", self.class, indexPath.row];
    return cell;
}
#endif

@end
