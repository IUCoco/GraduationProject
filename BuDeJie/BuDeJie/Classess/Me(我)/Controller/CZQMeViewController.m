//
//  CZQMeViewController.m
//  BuDeJie
//
//  Created by 陈志强 on 16/11/21.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQMeViewController.h"
#import "CZQSettingViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "CZQCollectionItem.h"
#import "CZQCollectionViewCell.h"
#import <SafariServices/SafariServices.h>
#import "CZQRegisterAndLoginViewController.h"
#import "CZQBacklogViewController.h"
#import "IDAuthViewController.h"


static NSString * const ID = @"collectionCell";
//共四列
static NSInteger cols = 4;
//间距1
static CGFloat margin = 1;
//----------每个item的宽高
#define itemWH (CZQScreenWith - (cols - 1) * margin) / cols

@interface CZQMeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
//模型数组
@property(nonatomic, strong)NSMutableArray *collectionItemsArr;
//collectionView
@property(nonatomic, weak)UICollectionView *collectionView;

//第一个Section显示文字
@property (weak, nonatomic) IBOutlet UILabel *loginAndRegister;
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *headPortraitImageV;

//记录登录成功与否状态
@property (nonatomic, assign, getter=isLoginSuccess) BOOL loginSuccess;

@end

@implementation CZQMeViewController

-(NSMutableArray *)collectionItemsArr {
    if (!_collectionItemsArr) {
        _collectionItemsArr = [CZQCollectionItem mj_objectArrayWithFilename:@"collection.plist"];
        //处理请求完成数据，重新填充获得_collectionItemsArr的count，填充缺少的item
        [self resolveData];
        //------------------设置collectionView的高度-----------------
        //rows = ((count - 1） / cols) + 1
        NSInteger count = _collectionItemsArr.count;
        NSInteger rows = ((count - 1) / cols) + 1;
        self.collectionView.czq_hight = rows * itemWH;
        //重新制定tableView滚动范围,重新设置下footerView,tableView的滚动范围由内容系统自行计算
        self.tableView.tableFooterView = self.collectionView;
        //------------------设置collectionView的高度-----------------
        //刷新collectionView数据
        [self.collectionView reloadData];
    }
    return _collectionItemsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //设置导航条
    [self setUpNavBar];
    //设置footView的底部视图九宫格
    [self setUpFootView];
    //加载数据
//    [self setUpData];
    //处理tableView的分组样式
    self.tableView.sectionFooterHeight = 25;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(- 10, 0, 10, 0);
    //添加通知
    [self addObersvers];
}

#pragma mark - 加载数据
- (void)setUpData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    [manager GET:CZQCommonURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
        //写入plist
//        BOOL fileN = [responseObject writeToFile:@"/Users/kikyo/Desktop/collection1.plist" atomically:YES];
//        CZQAFNWriteToPlist(@"collection");
        //字典数组转模型数组 url(跳转地址) name icon(图片地址)
        NSArray *dataArr = responseObject[@"square_list"];
        _collectionItemsArr = [CZQCollectionItem mj_objectArrayWithKeyValuesArray:dataArr];
        //处理请求完成数据，重新填充获得_collectionItemsArr的count，填充缺少的item
        [self resolveData];
        //------------------设置collectionView的高度-----------------
        //rows = ((count - 1） / cols) + 1
        NSInteger count = _collectionItemsArr.count;
        NSInteger rows = ((count - 1) / cols) + 1;
        self.collectionView.czq_hight = rows * itemWH;
        //重新制定tableView滚动范围,重新设置下footerView,tableView的滚动范围由内容系统自行计算
        self.tableView.tableFooterView = self.collectionView;
        //------------------设置collectionView的高度-----------------
        //刷新collectionView数据
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 处理请求完成数据，填充缺少的item
- (void)resolveData{
     //判断下缺几个补几个 3 % 4 = 3 缺1个 9 % 4 = 1 缺3个
    NSInteger count = self.collectionItemsArr.count;
    //缺少的数目
    NSInteger exture = count % cols;
    //exture大于0才设置
    if (exture) {
        //缺少的数目
        exture = cols - exture;
        //遍历创建模型
        for (int i = 0; i < exture; i ++) {
            CZQCollectionItem *extureItem =[[CZQCollectionItem alloc] init];
            [self.collectionItemsArr addObject:extureItem];
        }
    }
}

#pragma mark - 设置footView的底部视图九宫格
- (void)setUpFootView{
    //创建九宫格步骤
    //1.必须创建流水布局 UICollectionViewFlowLayout
    //2.必自定义cell
    //3.必修注册cell
    
    
    //创建FlowLayout
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
//    //共四列
//    NSInteger cols = 4;
//    //间距1
//    CGFloat margin = 1;
//    //----------每个item的宽高
//    CGFloat itemWH = (CZQScreenWith - (cols - 1) * margin) / cols;
    collectionViewLayout.itemSize = CGSizeMake(itemWH, itemWH);
    collectionViewLayout.minimumLineSpacing = margin;
    collectionViewLayout.minimumInteritemSpacing = margin;
    //----------每个item的宽高
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:collectionViewLayout];
    _collectionView = collectionView;
    collectionView.backgroundColor = self.tableView.backgroundColor;
    //设置collectionView不能滚动
    collectionView.scrollEnabled = NO;
    //设置tableView的footerView为collectionView
    self.tableView.tableFooterView = collectionView;
    //设置数据源代理
    collectionView.dataSource = self;
    //设置代理
    collectionView.delegate = self;
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"CZQCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CZQLog(@"点击了item");
    //选中待办事项
    if (indexPath.row == 0) {
        CZQLog(@"选中了待办事项");
        CZQBacklogViewController *backlogVC = [[CZQBacklogViewController alloc] init];
        [self.navigationController pushViewController:backlogVC animated:YES];
    }
    //取出item中的url
    CZQCollectionItem *item = self.collectionItemsArr[indexPath.item];
    NSURL *url = [NSURL URLWithString:item.url];
    //处理url类型为http
    if ([item.url containsString:@"http"]) {
        SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:url];
//        //隐藏navication导航栏
//        self.navigationController.navigationBarHidden = YES;
//        //设置代理监听结束动作（返回）
//        sfVC.delegate = self;
//        //跳转至指定的url
//        [self.navigationController pushViewController:sfVC animated:YES];
        //使用modal方式跳转 ,苹果推荐使用modal,而且modal帮助实现了跳转回去的实现
        [self presentViewController:sfVC animated:YES completion:^{
            
        }];
        
    }else{
        return;
    }
   
}

//#pragma mark - SFSafariViewControllerDelegate
//- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
//    //设置代理监听结束动作（返回）
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - UICollectionViewDataSource
//设置section中的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionItemsArr.count;
}

//设置每个item的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CZQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%@", cell);
    //给cell设置模型数组
    cell.item = self.collectionItemsArr[indexPath.item];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"++++++%ld----", indexPath.row);
    if (indexPath.section == 0 && !self.isLoginSuccess) {
        CZQLog(@"登录注册");
        CZQRegisterAndLoginViewController *reginAndLoginVC = [[CZQRegisterAndLoginViewController alloc] init];
        //跳转至注册登录界面 modal效果
        [self presentViewController:reginAndLoginVC animated:YES completion:nil];
    }else if (indexPath.section == 1) {
        CZQLog(@"名片扫描");
        IDAuthViewController *idAuthVC = [[IDAuthViewController alloc] init];
        [self.navigationController pushViewController:idAuthVC animated:YES];
        
    }else if (indexPath.section == 0 && self.isLoginSuccess) {
        NSLog(@"展示个人信息咯");
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
    self.loginAndRegister.text = @"欢迎Kikyo";
    self.headPortraitImageV.image = [UIImage imageNamed:@"logo_login"];
    [self.tableView reloadData];
}


- (void)dealloc {
    [self removeObservers];
}

#pragma mark - 设置导航条
- (void)setUpNavBar{
    //左边按钮夜间模式
    UIImage *rightNightNorImage = [UIImage imageNamed:@"mine-moon-icon"];
    UIImage *rightNightSelImage = [UIImage imageNamed:@"mine-moon-icon-click"];
    //调用UIBarButtonItem分类直接生成需要的buttonItem
    UIBarButtonItem *rightNightBtnItem = [UIBarButtonItem itemWithNorImage:rightNightNorImage selImage:rightNightSelImage target:self action:@selector(MeRightNightBtnClick:)];
    //左边按钮设置模式
    UIImage *rightSetNorImage = [UIImage imageNamed:@"mine-setting-icon"];
    UIImage *rightSetHighImage = [UIImage imageNamed:@"mine-setting-icon-click"];
    //调用UIBarButtonItem分类直接生成需要的buttonItem
    UIBarButtonItem *rightSetBtnItem = [UIBarButtonItem itemWithNorImage:rightSetNorImage highImage:rightSetHighImage target:self action:@selector(MeRightSetBtnClick)];
    
    self.navigationItem.rightBarButtonItems = @[rightSetBtnItem, rightNightBtnItem];
    //中间文字
    self.navigationItem.title = @"我的";
}

- (void)MeRightNightBtnClick:(UIButton *)NightBtn{
    NightBtn.selected = !NightBtn.selected;
    NSLog(@"MeRightNightBtnClick");
}

- (void)MeRightSetBtnClick{
    NSLog(@"MeRightSetBtnClick");
    //设置跳转控制器界面
    CZQSettingViewController *settingVC = [[CZQSettingViewController alloc] init];
    //设置导航条中间文字
    settingVC.navigationItem.title = @"设置";
    //跳转之前隐藏底部
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
    
}


@end
