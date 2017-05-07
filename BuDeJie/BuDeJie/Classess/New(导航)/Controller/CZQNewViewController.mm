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
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <Masonry.h>

#import "RouteAnnotation.h"
#import "UIImage+Rotate.h"

@interface CZQNewViewController ()<BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, UITextFieldDelegate, BMKRouteSearchDelegate, BMKGeoCodeSearchDelegate>

/** 地图 */
@property (nonatomic, strong) BMKMapView *mapView;
/** 检索对象 */
@property (nonatomic, strong) BMKPoiSearch *searcher;
/** 定位功能 */
@property (nonatomic, strong) BMKLocationService *locService;
/** 检索框 */
@property (nonatomic, strong) UITextField *textF;

@property (nonatomic, strong) BMKUserLocation *userLocation;
/** 路径规划 */
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

/** 地理编码管理器 */
@property (nonatomic, strong) CLGeocoder *geoC;

@property (nonatomic, strong) BMKGeoCodeSearch *geoSearcher;

//自己地址坐标
@property (nonatomic, assign) CLLocationCoordinate2D selfLocation;
//目标地址坐标
@property (nonatomic, assign) CLLocationCoordinate2D aidLocation;


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

/** 路径规划 */

- (BMKRouteSearch *)routeSearch {
    if (!_routeSearch) {
        _routeSearch = [[BMKRouteSearch alloc] init];
        //设置delegate，用于接收检索结果
        _routeSearch.delegate = self;
    }
    return _routeSearch;
}

/** 地理编码管理器 */
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (BMKGeoCodeSearch *)geoSearcher {
    if (!_geoSearcher) {
        _geoSearcher = [[BMKGeoCodeSearch alloc] init];
        _geoSearcher.delegate = self;
    }
    
    return _geoSearcher;
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
    //路径规划
    [self routeSearch];
    //地理编码
    [self geoSearcher];
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
    _geoSearcher.delegate = nil;
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
    
    self.userLocation = userLocation;
    
    
//    //地理反编码获取当前位置具体信息
//    [self.geoC reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        CLPlacemark *pl = [placemarks firstObject];
//        
//        if(error == nil)
//        {
//            NSLog(@"locality:%@--++++-subLocality:%@-++++--%@", pl.locality, pl.subLocality, pl.administrativeArea);
////            locality:杭州市--++++-subLocality:江干区-++++--浙江省
//        }
//        
//    }];
    
    //发起反向地理编码检索 获取当前位置具体信息
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geoSearcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
    
    

}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      NSLog(@"Success找到结果");
      CZQLog(@"%@+++++++++%@++++++++%@+++++%zd", result.addressDetail, result.address, result.businessCircle, result.location);
      self.selfLocation = result.location;
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
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
        make.width.mas_equalTo(150);
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

//自定义大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.pinColor = BMKPinAnnotationColorRed;
    newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
    newAnnotationView.annotation=annotation;
//    newAnnotationView.image = [UIImage imageNamed:@"mainCellCommentClick"];   //把大头针换成别的图片
    UIButton *navigateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navigateBtn.frame = CGRectMake(0, 0, 32, 20);
    navigateBtn.titleLabel.font = [UIFont systemFontOfSize:6];
    navigateBtn.backgroundColor = [UIColor grayColor];
    [navigateBtn.layer setMasksToBounds:YES];
    [navigateBtn.layer setCornerRadius:5.0];
    [navigateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [navigateBtn setTitle:@"点击导航" forState:UIControlStateNormal];
    [navigateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigateBtn addTarget:self action:@selector(navigateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    newAnnotationView.rightCalloutAccessoryView = navigateBtn;
    
    return newAnnotationView;
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

#pragma mark - 路径规划

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    NSLog(@"%@-----%@--+++%zd", view.annotation.title, view.annotation.subtitle, view.annotation.coordinate);
    self.aidLocation = view.annotation.coordinate;
}

//大头针导航按钮点击
- (void)navigateBtnClick {
    CZQLog(@"大头针导航按钮点击");
    //构造公共交通路线规划检索信息类
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
//    start.name = @"滨江";
//    start.cityName = @"杭州";
    start.pt = self.selfLocation;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
//    end.name = @"萧山";
//    CLLocationCoordinate2D
//    end.cityName = @"杭州";
    end.pt = self.aidLocation;
    BMKWalkingRoutePlanOption *option = [[BMKWalkingRoutePlanOption alloc]init];
    option.from = start;
    option.to = end;
    //发起检索
    BOOL flag = [_routeSearch walkingSearch:option];
    
    if(flag) {
        NSLog(@"步行检索  发送成功");
    } else {
        NSLog(@"步行检索  发送失败");
    }
}


/**
 *返回步行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKWalkingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //成功获取结果
        CZQLog(@"检索结果正常返回");
    } else {
        //检索失败
    }
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }
            if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
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
