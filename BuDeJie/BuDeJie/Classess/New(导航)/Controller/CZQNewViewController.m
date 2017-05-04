//
//  CZQNewViewController.m
//  BuDeJie
//
//  Created by 陈志强 on 16/11/21.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQNewViewController.h"
#import "CZQFllowViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import<BaiduMapAPI_Location/BMKLocationComponent.h>
#import <Masonry.h>

@interface CZQNewViewController ()<BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, UITextFieldDelegate>

/** 地图 */
@property (nonatomic, strong) BMKMapView *mapView;
/** 检索对象 */
@property (nonatomic, strong) BMKPoiSearch *searcher;
/** 定位功能 */
@property (nonatomic, strong) BMKLocationService *locService;
/** 检索框 */
@property (nonatomic, strong) UITextField *textF;

@property (nonatomic, strong) BMKUserLocation *userLocation;

@property (nonatomic, strong) NSMutableArray *poiInfoArrM;

@end

@implementation CZQNewViewController

#pragma mark - lazy
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.zoomLevel = 21;
        [self.view addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _mapView;
}

/** 检索对象 */
- (BMKPoiSearch *)searcher
{
    if (!_searcher) {
        _searcher = [[BMKPoiSearch alloc] init];
        _searcher.delegate = self;
    }
    return _searcher;
}

/** 定位功能 */
- (BMKLocationService *)locService {
    if (!_locService) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        //设定定位精度
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
        //开启定位
        [_locService startUserLocationService];
    }
    return _locService;
}

- (NSMutableArray *)poiInfoArrM {
    if (!_poiInfoArrM) {
        _poiInfoArrM = [NSMutableArray array];
    }
    return _poiInfoArrM;
}

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航条
    [self setUpNavBar];
    //设置mapView
    [self mapView];
    //设置定位
    [self locService];
    //设置搜索栏
    [self setupSearch];
}

/**
 自2.0.0起，BMKMapView新增viewWillAppear、viewWillDisappear方法来控制BMKMapView的生命周期，并且在一个时刻只能有一个BMKMapView接受回调消息，因此在使用BMKMapView的viewController中需要在viewWillAppear、viewWillDisappear方法中调用BMKMapView的对应的方法，并处理delegate
 */

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
}

- (void)dealloc
{
    if (self.mapView)
    {
        self.mapView = nil;
    }
}

#pragma mark - 定位功能

/** 用户位置更新后，会调用此函数 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    //展示定位
    self.mapView.showsUserLocation = YES;

    //更新位置数据
    [self.mapView updateLocationData:userLocation];
    
    //获取用户的坐标
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    self.mapView.zoomLevel = 18;
    
//    //初始化一个周边云检索对象
//    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
//    
//    //索引 默认为0
//    option.pageIndex = 0;
//    
//    //页数默认为10
//    option.pageCapacity = 50;
//    
//    //搜索半径
//    option.radius = 200;
//    
//    //检索的中心点，经纬度
//    option.location = userLocation.location.coordinate;
//    
//    //搜索的关键字
//    option.keyword = @"小吃";
//    
//    
//    
//    //根据中心点、半径和检索词发起周边检索
//    BOOL flag = [self.searcher poiSearchNearBy:option];
//    if (flag) {
//        NSLog(@"搜索成功");
//        //关闭定位
//        [self.locService stopUserLocationService];
//    }
//    else {
//        
//        NSLog(@"搜索失败");
//    }
    
    self.userLocation = userLocation;

}

#pragma mark - 检索功能

//设置检索

- (void)setupSearch {
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CZQScreenWith, 49)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    UILabel *searchLlab = [[UILabel alloc] init];
    searchLlab.text = @"搜索:";
    searchLlab.textColor = [UIColor blackColor];
    [searchView addSubview:searchLlab];
    [searchLlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView.mas_centerY);
        make.left.equalTo(searchView.mas_left).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    UITextField *textF = [[UITextField alloc] init];
    textF.delegate = self;
    textF.returnKeyType = UIReturnKeyDone;
    textF.borderStyle = UITextBorderStyleRoundedRect;
    textF.text = @"小吃";
    [searchView addSubview:textF];
    self.textF = textF;
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView.mas_centerY);
        make.left.equalTo(searchLlab.mas_right).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"点击搜索" forState:UIControlStateNormal];
//    searchBtn.backgroundColor = [UIColor grayColor];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView.mas_centerY);
        make.right.equalTo(searchView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    
}

//开始检索
- (void)beginSearch {
    //初始化一个周边云检索对象
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    
    //索引 默认为0
    option.pageIndex = 0;
    
    //页数默认为10
    option.pageCapacity = 50;
    
    //搜索半径
    option.radius = 1000;
    
    //检索的中心点，经纬度
    option.location = self.userLocation.location.coordinate;
    
    //搜索的关键字
    option.keyword = self.textF.text;
    
    
    
    //根据中心点、半径和检索词发起周边检索
    BOOL flag = [self.searcher poiSearchNearBy:option];
    if (flag) {
        NSLog(@"搜索成功");
        //关闭定位
        [self.locService stopUserLocationService];
    }
    else {
        
        NSLog(@"搜索失败");
    }
}

//BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"检索结果正常返回");
        [_mapView removeAnnotations:_mapView.annotations];
        [poiResult.poiInfoList enumerateObjectsUsingBlock:^(BMKPoiInfo  *_Nonnull poiInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@---------%@", poiInfo.name, poiInfo.address);
            
            // 添加一个PointAnnotation
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = poiInfo.pt;
            annotation.title = poiInfo.name;
            annotation.subtitle = poiInfo.address;
            [_mapView addAnnotation:annotation];
        }];
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

//textF 取消第一响应者
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
    return YES;
}

//搜索按钮点击
- (void)searchBtnClick {
    NSLog(@"searchBtnClick");
    [self beginSearch];
}


#pragma mark - 设置导航条
- (void)setUpNavBar{
    //左边按钮
    UIImage *leftNorImage = [UIImage imageNamed:@"MainTagSubIcon"];
    UIImage *leftHighImage = [UIImage imageNamed:@"MainTagSubIconClick"];
    //调用UIBarButtonItem分类直接生成需要的buttonItem
    UIBarButtonItem *leftBtnItem = [UIBarButtonItem itemWithNorImage:leftNorImage highImage:leftHighImage target:self action:@selector(newLeftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    //中间图片
//    UIImage *centerImage = [UIImage imageNamed:@"MainTitle"];
//    UIImageView *centerImageView = [[UIImageView alloc] initWithImage:centerImage];
//    self.navigationItem.titleView = centerImageView;
    self.navigationItem.title = @"周边导航";
    
    
}

- (void)newLeftBtnClick{
    NSLog(@"newLeftBtnClick");
    //跳转至关注Follow控制器页面
    CZQFllowViewController *followVC = [[CZQFllowViewController alloc] init];
    NSLog(@"%@",self.navigationController);
    [self.navigationController pushViewController:followVC animated:YES];
    
}


@end
