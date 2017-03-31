//
//  videoViewController.m
//  music
//
//  Created by sghy on 17/3/14.
//  Copyright © 2017年 lzj. All rights reserved.
//
#import <CoreLocation/CLLocationManager.h>
#import "videoViewController.h"
#import "PYSearchViewController.h"
#import "routeVCViewController.h"
#import "RouteAnnotation.h"
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import "ZZiflyTool.h"
@interface videoViewController ()
<BMKMapViewDelegate,
BMKLocationServiceDelegate,
BMKPoiSearchDelegate,
BMKGeoCodeSearchDelegate,
UITextFieldDelegate,
PYSearchViewControllerDelegate,
BMKRouteSearchDelegate,
IFlyRecognizerViewDelegate>

@property (nonatomic, strong) UIButton * showUserLocationBtn;//右下小蓝点
@property (nonatomic, strong) UIButton * routeBtn;//路线规划
@property (nonatomic, strong) UITextField * tf;//输入框
@property (nonatomic, strong) UIView * searchBackView;
@property (nonatomic, strong) UIButton * voiceBtn;

@property (nonatomic, strong) BMKMapView* mapView;//地图视图
@property (nonatomic, strong) BMKLocationService* locService;//定位服务
@property (nonatomic, strong) BMKPoiSearch* nearbySearch;//poi周边搜索
@property (nonatomic, strong) BMKPoiSearch* cityPoiSearcher;//poi城市搜索
@property (nonatomic, strong) BMKRouteSearch * routeSearcher;//路线搜索
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch; //根据地址名称获取地理信息
@property (nonatomic, strong) BMKUserLocation * userLocation;//当前位置 PYSearchViewController
@property (nonatomic, strong) BMKPointAnnotation* annotation; //标注
@property (nonatomic, strong) PYSearchViewController* searchGestVC; //搜索控制器
@property (nonatomic, strong) routeVCViewController * routeVC;//规划路线控制器

@property (nonatomic ,strong) NSMutableArray * addresss;//地理信息 编码
@property (nonatomic, strong) NSMutableArray * poiNearbyAdress;//存储周围搜索地址结果信息
@property (nonatomic, strong) NSMutableArray * poiCityAdress;//存储城市搜索地址结果信息
@property (nonatomic, assign) CLLocationCoordinate2D leftButtom;//左下角
@property (nonatomic, assign) CLLocationCoordinate2D rightTop;//右上角
@property (nonatomic, strong) NSString * userCity;//定位城市
@property (nonatomic, strong) NSString * startStr;//规划路线起始位置
@property (nonatomic, strong) NSString * endStr;//规划路线终止位置
@property (nonatomic, assign) BOOL isFirstLocation;//是否第一次定位
@property (nonatomic, assign) SerchType searchType;
@end

@implementation videoViewController
#pragma mark ---视图将要出现---
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    ShareApp.drawerController.isOpen = NO;
    //地图视图代理
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //搜索delegate
    _geocodesearch.delegate = self;
    //pio搜索delegate
    _nearbySearch.delegate = self;
    _cityPoiSearcher.delegate = self;
    _routeSearcher.delegate = self;
    _searchType = searchDefault;
}
#pragma mark ---视图将要消失---
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    ShareApp.drawerController.isOpen = YES;
    _mapView.delegate = nil;
    _geocodesearch.delegate = nil;
    _nearbySearch.delegate = nil;
    _routeSearcher.delegate = nil;
//    _cityPoiSearcher.delegate = nil;
    
}
#pragma mark ---视图加载---
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLocation];
    
    _isFirstLocation = YES;

    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    
    _nearbySearch = [[BMKPoiSearch alloc]init];
    _nearbySearch.delegate = self;
    
    _cityPoiSearcher = [[BMKPoiSearch alloc]init];
    _cityPoiSearcher.delegate = self;
    
    _routeSearcher = [[BMKRouteSearch alloc]init];
    _routeSearcher.delegate = self;
    
    self.view = self.mapView;
    [_mapView addSubview:self.searchBackView];
    [_searchBackView addSubview:self.tf];
    [_searchBackView addSubview:self.voiceBtn];
    [_mapView addSubview:self.showUserLocationBtn];
    [_mapView addSubview:self.routeBtn];
    
    //百度地图中坐标点和地图中经纬度的转换
    // CLLocationCoordinate2D firstLocation=[baiduMapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:baiduMapView];//这个是远点的经纬度
}
#pragma mark ----语音--
- (void)voiceBtnClick
{
    [[ZZiflyTool shareTool] startRecognizer:^(IFlySpeechError *error, NSString *result) {
        if (error)
        {
            [PubFunction showMessage:error.errorDesc keepTime:1.5];
            return;
        }
        if ([result isEqualToString:@"。"]) {
            return;
        }
        NSSLog(@"语音识别: %@",result);
         [PubFunction showMessage:result keepTime:1.5];
    }];
}
#pragma mark 视图切换到当前位置  ---点击右下小圆点
- (void)shaowUserLocationClick
{
    if(_showUserLocationBtn.selected)
    {
        _showUserLocationBtn.selected = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeHeading;
    }
    else
    {
        _showUserLocationBtn.selected = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    }
    //    [self geteCcodeSearchOption:_userLocation];
    _mapView.centerCoordinate = _userLocation.location.coordinate; //更新当前位置到地图中间
}
#pragma mark 路线规划按钮
- (void)routeBtnClick
{
    __block videoViewController * weakVC = self;
    _routeVC = [[routeVCViewController alloc]init];
    self.searchType = searchDefault;
    _routeVC.backBlock = ^(SerchType type)
    {
        weakVC.searchType = type;
        [weakVC textFieldDidBeginEditing:weakVC.tf];
        
    };
    _routeVC.routeBlock = ^(NSString * stratStr , NSString * endStr)
    {
        weakVC.startStr = stratStr;
        weakVC.endStr = endStr;
        [weakVC roteSearch];
    };
    [self.navigationController pushViewController:_routeVC animated:NO];
}
#pragma mark 创建路线规划
- (void)roteSearch
{
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.name = _startStr;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    
    end.name = _endStr;
    
    start.cityName = self.userCity;
    
    end.cityName = self.userCity;
    
    BMKDrivingRoutePlanOption *driveRouteSearchOption =[[BMKDrivingRoutePlanOption alloc]init];
    
    driveRouteSearchOption.from = start;
    
    driveRouteSearchOption.to = end;
    
    BOOL isSuccess = [_routeSearcher drivingSearch:driveRouteSearchOption];
    if (isSuccess)
    {
        NSSLog(@"路线规划成功");
    }
    else
    {
        NSSLog(@"路线规划失败");
    }
}
#pragma mark 获取路线的标注，显示到地图
//- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation{
//    
//    BMKAnnotationView *view = nil;
//    switch (routeAnnotation.type) {
//        case 0:
//        {
//            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
//            if (view == nil) {
//                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
//                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start"]];
//                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
//                view.canShowCallout = true;
//            }
//            view.annotation = routeAnnotation;
//        }
//            break;
//        case 1:
//        {
//            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
//            if (view == nil) {
//                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
//                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end"]];
//                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
//                view.canShowCallout = true;
//            }
//            view.annotation =routeAnnotation;
//        }
//            break;
//        case 4:
//        {
//            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
//            if (view == nil) {
//                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
//                view.canShowCallout = true;
//            } else {
//                [view setNeedsDisplay];
//            }
//            UIImage *image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction"]];
//            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
//            view.annotation = routeAnnotation;
//        }
//            break;
//        default:
//            break;
//    }
//    return view;
//}
#pragma mark 路线规划成功结果回调代理
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        //表示一条驾车路线
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            //表示驾车路线中的一个路段
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加终点标注
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
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
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
#pragma mark  根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    
    if (polyLine.pointCount < 1) return;
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    
    for (int i = 0; i < polyLine.pointCount; i++) {
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
#pragma mark 根据overlay生成对应的View
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
#pragma mark 手指开始拖动
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    _showUserLocationBtn.selected = YES;
}
#pragma mark 视图加载完毕先调取一次检索
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    _leftButtom = [_mapView convertPoint:CGPointMake(0,_mapView.frame.size.height) toCoordinateFromView:mapView];  // //西南角（左下角） 屏幕坐标转地理经纬度
    _leftButtom = [_mapView convertPoint:CGPointMake(_mapView.frame.size.width,0) toCoordinateFromView:mapView];  //东北角（右上角）同上
}
#pragma mark 开始poi周边搜索
- (void)beginSearch:(NSString *)searchKey{
    
    //矩形范围搜索
    //    BMKBoundSearchOption *boundSearchOption = [[BMKBoundSearchOption alloc]init];
    //    boundSearchOption.pageIndex = 0;
    //    boundSearchOption.pageCapacity = 20;
    //    boundSearchOption.keyword = searchKey;
    //    boundSearchOption.leftBottom =_leftButtom;
    //    boundSearchOption.rightTop =_leftButtom;
    //
    //    BOOL flag = [_searcher poiSearchInbounds:boundSearchOption];
    //    if(flag)
    //    {
    //        NSSLog(@"范围内检索发送成功");
    //    }
    //    else
    //    {
    //        NSSLog(@"范围内检索发送失败");
    //    }
    
    //发起周边检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 20;
    option.location = _userLocation.location.coordinate;
    option.keyword = searchKey;
    BOOL flag = [_nearbySearch poiSearchNearBy:option];
    if(flag) {
        NSSLog(@"周边检索发送成功");
    } else {
        NSSLog(@"周边检索发送失败");
    }
    
    // 设置初始化区域
    CLLocationCoordinate2D center = option.location;
    BMKCoordinateSpan span;
    span.latitudeDelta = 0.016263;
    span.longitudeDelta = 0.012334;
    BMKCoordinateRegion region;
    region.center = center;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}
#pragma mark 显示区域改变
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    _leftButtom = [_mapView convertPoint:CGPointMake(0,_mapView.frame.size.height) toCoordinateFromView:mapView];  // //西南角（左下角） 屏幕坐标转地理经纬度
    _leftButtom = [_mapView convertPoint:CGPointMake(_mapView.frame.size.width,0) toCoordinateFromView:mapView];  //东北角（右上角）同上
}
#pragma mark poi检索成功后
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)//在此处理正常结果
    {
        if (searcher == _cityPoiSearcher)
        {
            [self.poiCityAdress removeAllObjects];
            [poiResultList.poiInfoList enumerateObjectsUsingBlock:^(BMKPoiInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                [self.poiCityAdress addObject:obj.name];
            }];
            //更新模糊信息列表
            _searchGestVC.searchSuggestions = self.poiCityAdress;
        }
        else if (searcher == _nearbySearch)
        {
            [poiResultList.poiInfoList enumerateObjectsUsingBlock:^(BMKPoiInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //            NSLog(@"%@----%@", obj.name, obj.address);  // 由于设置检索时，每页指定了10条，所以此处检索出10条相关信息
                [self addAnnoWithPT:obj.pt andTitle:obj.name andAddress:obj.address];
                if (idx ==0)
                {
                    _mapView.centerCoordinate =obj.pt;//更新地图显示中心为搜索结果
                }
            }];
        }

    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSSLog(@"起始点有歧义");
    } else
    {
        NSSLog(@"抱歉，未找到结果");
    }
}
#pragma mark 方向变更
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSSLog(@"heading is %@",userLocation.heading);
    [_mapView updateLocationData:userLocation];
    _userLocation = userLocation;
    
}
#pragma mark 坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSSLog(@"经纬: lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    _userLocation = userLocation;
    if (_isFirstLocation)
    {
        _isFirstLocation = NO;
        _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
        
        BMKCoordinateRegion region;
        
        region.center.latitude  = userLocation.location.coordinate.latitude;
        region.center.longitude = userLocation.location.coordinate.longitude;
        region.span.latitudeDelta = 0;
        region.span.longitudeDelta = 0;
        NSSLog(@"当前的坐标是:%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation: userLocation.location completionHandler:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                CLPlacemark *placemark = [array objectAtIndex:0];
                if (placemark != nil) {
                    NSString *city = placemark.locality;
                    _userCity = city;
                    NSSLog(@"当前城市名称------%@",city);
                    BMKOfflineMap * _offlineMap = [[BMKOfflineMap alloc] init];
                    NSArray* records = [_offlineMap searchCity:city];
                    BMKOLSearchRecord* oneRecord = [records objectAtIndex:0];
                    //城市编码如:北京为131
                    NSInteger cityId = oneRecord.cityID;
                    NSSLog(@"当前城市编号-------->%zd",cityId);
                    //找到了当前位置城市后就关闭服务
//                    [_locService stopUserLocationService];
                }
            }
        }];
    }
}
#pragma mark 经纬转地址  反编码
- (void)geteCcodeSearchOption:(BMKUserLocation *)userLocation
{
    //地理反编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSSLog(@"反geo检索发送成功");
    }else{
        NSSLog(@"反geo检索发送失败");
    }
}
#pragma mark 点击地图中的标注
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    if (!_annotation)
    {
        _annotation = [[BMKPointAnnotation alloc]init];
        [_mapView addAnnotation:_annotation];
    }
    else
    {
        _annotation.coordinate = mapPoi.pt;
        _annotation.title = mapPoi.text;
    }
}
#pragma mark 点击地图空白处 ---取消点击标注
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    [_mapView removeAnnotation:_annotation];
    _annotation = nil;
    
}
#pragma mark 创建标注后走的代理
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    static NSString *identifier = @"myAnnotation";
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!newAnnotationView) {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        newAnnotationView.annotation = annotation;
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        //添加按钮监听点击事件
        //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        //        newAnnotationView.rightCalloutAccessoryView = btn;
        //        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        return newAnnotationView;
    }
    return nil;
}
#pragma mark 添加Annotation标注点
- (void)addAnnoWithPT:(CLLocationCoordinate2D)coor andTitle:(NSString *)title andAddress:(NSString *)address {
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coor;
    annotation.title = title;
    annotation.subtitle = address;
    [_mapView addAnnotation:annotation];
    [self.poiNearbyAdress addObject:annotation];
}
#pragma mark -------------地理反编码结果---------------
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < result.poiList.count; i++) {
            BMKPoiInfo* poi = [result.poiList objectAtIndex:i];
            BMKReverseGeoCodeResult * addressModel = [[BMKReverseGeoCodeResult alloc]init];
            addressModel.address = poi.address;
            addressModel.location = poi.pt;
            [array addObject:addressModel];
        }
        self.addresss = [NSMutableArray arrayWithArray:array];
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
    self.navigationItem.title = result.address;
}

#pragma mark - textFielDelegate
-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    [textField resignFirstResponder];
    // 1.创建热门搜索
    
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入地址" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        //先清除所有已有标注 先清除图上标注 再清空数据
        [_mapView removeAnnotations:_poiNearbyAdress];
        [_poiNearbyAdress removeAllObjects];
        
        //
        [_mapView removeOverlays:_mapView.overlays];
        NSArray *annArray = [[NSArray alloc]initWithArray:_mapView.annotations];
        [_mapView removeAnnotations: annArray];
        // 开始搜索执行以下代码
        if (_searchType == searchDefault)
        {
            //发起检索
            [self beginSearch:searchText];
        }
        else if (_searchType == searchStart)
        {
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:searchText,@"start", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RouteChangeTF object:dic];
            _searchType = searchDefault;
        }
        else if (_searchType == searchEnd)
        {
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:searchText,@"end", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RouteChangeTF object:dic];
            _searchType = searchDefault;
        }
        [searchViewController.navigationController popViewControllerAnimated:YES];
    }];
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag; // 热门搜索风格根据选择
//    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault; // 搜索历史风格为
    searchViewController.delegate = self;
    if (_searchType != searchDefault)
    {
        [_routeVC.navigationController pushViewController:searchViewController animated:NO];
    }else
    {
        [self.navigationController pushViewController:searchViewController animated:NO];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 搜索框中的模糊搜索
- (void)fuzzySearch:(NSString *)searchText
{
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city= _userCity;
    citySearchOption.keyword = searchText;
    BOOL isSuccess = [_cityPoiSearcher poiSearchInCity:citySearchOption];
    if (isSuccess)
    {
        NSSLog(@"城市检索成功");
    }
    else
    {
        NSSLog(@"城市检索失败");
    }
}
#pragma mark - PYSearchViewControllerDelegate 改变就调用
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length)
    { // 与搜索条件再搜索
        //记录搜索界面控制器  城市检索完成需要刷新 用来展示模糊信息
        _searchGestVC = searchViewController;
        //发起城市检索
        [self fuzzySearch:searchText];
    }
}
#pragma mark 从搜索界面点击了取消按钮
- (void)didClickCancel:(PYSearchViewController *)searchViewController
{
    
}
#pragma mark 判断定位是否开启
- (void)initLocation{
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        [self setLocation];
        //定位功能可用
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                      message:@"请确认打开了定位服务,且允许程序获取位置"
                                                     delegate:self
                                            cancelButtonTitle:@"去设置"
                                            otherButtonTitles:@"就不", nil];
        [alt handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
            if (btnIndex == 0) {
                if (![CLLocationManager locationServicesEnabled])
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }
        }];
        [alt show];
    }
}
#pragma mark 设置定位参数 开始定位
- (void)setLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //设置定位精度
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10.0;
    _locService.distanceFilter = distance;
    [_locService startUserLocationService];
}
#pragma mark 懒加载
- (NSMutableArray *)poiNearbyAdress
{
    if (!_poiNearbyAdress)
    {
        _poiNearbyAdress = [[NSMutableArray alloc]init];
    }
    return _poiNearbyAdress;
}
- (NSMutableArray *)poiCityAdress
{
    if (!_poiCityAdress)
    {
        _poiCityAdress = [[NSMutableArray alloc]init];
    }
    return _poiCityAdress;
}
- (UIButton *)showUserLocationBtn
{
    if (!_showUserLocationBtn)
    {
        _showUserLocationBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 50, SCREEN_HEIGHT - 150, 30, 30)];
        _showUserLocationBtn.backgroundColor = [UIColor blueColor];
        [_showUserLocationBtn addTarget:self action:@selector(shaowUserLocationClick) forControlEvents:UIControlEventTouchUpInside];
        _showUserLocationBtn.layer.masksToBounds = YES;
        _showUserLocationBtn.layer.cornerRadius = _showUserLocationBtn.width/2;
    }
    return _showUserLocationBtn;
}
- (UIButton *)routeBtn
{
    if (!_routeBtn)
    {
        _routeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 80, SCREEN_HEIGHT - 250, 70, 70)];
        _routeBtn.backgroundColor = [UIColor blueColor];
        [_routeBtn setTitle:@"路线" forState:UIControlStateNormal];
        _routeBtn.layer.masksToBounds = YES;
        _routeBtn.layer.cornerRadius = _routeBtn.width/2;
        [_routeBtn addTarget:self action:@selector(routeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _routeBtn;
}
- (UIView *)searchBackView
{
    if (!_searchBackView)
    {
        _searchBackView = [[UIView alloc]initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH-60, 60)];
        _searchBackView.backgroundColor = [UIColor clearColor];
    }
    return _searchBackView;
}
- (UITextField *)tf
{
    if (!_tf)
    {
        _tf = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-60-20, 50)];
        [_tf setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
        _tf.delegate = self;
        _tf.placeholder = @"请输入地址"; //默认显示的字
        _tf.secureTextEntry = NO; //是否以密码形式显示
        _tf.autocorrectionType = UITextAutocorrectionTypeNo;
        _tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _tf;
}
- (UIButton *)voiceBtn
{
    if (!_voiceBtn)
    {
        _voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tf.frame) - 40, 15, 30, 30)];
        _voiceBtn.backgroundColor = [UIColor blueColor];
        _voiceBtn.layer.masksToBounds = YES;
        _voiceBtn.layer.cornerRadius = _voiceBtn.width/2;
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}
- (BMKMapView *)mapView
{
    if (!_mapView)
    {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mapView.logoPosition = BMKLogoPositionRightTop;
        _mapView.zoomLevel = 19;//地图显示比例
        _mapView.showMapScaleBar = YES; //比例尺
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态  这里需要设置为跟随状态，因为要在地图上能够显示当前的位置
        _mapView.showsUserLocation = YES;//显示定位图层 我的位置的小圆点
    }
    return _mapView;
}
@end
