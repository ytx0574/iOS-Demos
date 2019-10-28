//
//  SearchOnMapViewController.m
//  
//
//  Created by Johnson on 2019/8/23.
//

#import "SearchOnMapViewController.h"
#import <AMap3DMap/MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MACustomPointAnnotation.h"
#import "AddressDetailViewController.h"
#import "CommonUtility.h"
#import "MACustomPinAnnotationView.h"

typedef NS_ENUM(NSInteger, MapSearchType)
{
    MapSearchTypePOI = 0, //POI
    MapSearchTypeAround = 01, //周边
};

@interface SearchOnMapViewController () <UISearchBarDelegate, AMapSearchDelegate, MAMapViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIStepper *stepperZoomLevel;
@property (weak, nonatomic) IBOutlet UIStepper *stepperCameraDegree;

@property (nonatomic, strong) AMapSearchAPI *mapSearchAPI;
@property (nonatomic, strong) AMapPOISearchResponse *poiSearchResponse;

@property (nonatomic, assign) MapSearchType searchType;
@property (nonatomic, strong) AMapPOI *indexPOI; //当前记录的周边搜索位置
@property (nonatomic, strong) MACustomPointAnnotation *userCustomPointAnnotation; //用户长按标注
@end

@implementation SearchOnMapViewController

- (void)dealloc
{
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapSearchAPI = [[AMapSearchAPI alloc] init];
    self.mapSearchAPI.delegate = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    self.searchType = MapSearchTypePOI;
    self.stepperZoomLevel.value = self.mapView.zoomLevel;
    self.stepperZoomLevel.maximumValue = self.mapView.maxZoomLevel;
    self.stepperZoomLevel.minimumValue = self.mapView.minZoomLevel;
    self.stepperZoomLevel.stepValue = 1;
    
    self.stepperCameraDegree.value = self.mapView.cameraDegree;
    self.stepperCameraDegree.maximumValue = 60;
    self.stepperCameraDegree.minimumValue = 0;
    self.stepperCameraDegree.stepValue = 10;
    
    RAC(self.stepperCameraDegree, value) = [[RACObserve(self.mapView, cameraDegree) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal];

    
    if (self.defatultSearchText.length > 0) {
        self.searchBar.text = self.defatultSearchText;
        [self searchBarSearchButtonClicked:self.searchBar];
    }
    else if (self.poi) {
        [self showPointAnnotationWithPOIs:(AMapSearchObject *)self.poi.subPOIs];
    }
    else if (self.pois) {
        [self showPointAnnotationWithPOIs:self.pois];
    }
    // Do any additional setup after loading the view.
}

#pragma mark - Methods

// AMapPOI/AMapSubPOI
- (void)showPointAnnotationWithPOIs:(NSArray <AMapPOI *> *)pois;
{
    NSArray *ayAnnotations = [self.mapView.annotations.rac_sequence filter:^BOOL(id<MAAnnotation> value) {
        return ![value isEqual:self.userCustomPointAnnotation];
    }].array;
    [self.mapView removeAnnotations:ayAnnotations];
    
    NSArray <MAPointAnnotation *> *annotations = [pois.rac_sequence map:^id _Nullable(AMapPOI * _Nullable value) {
        MACustomPointAnnotation *pointAnnotation = [[MACustomPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(value.location.latitude, value.location.longitude);
        pointAnnotation.title = value.name;

        if ([value isKindOfClass:AMapSubPOI.class]) {
            pointAnnotation.subtitle = [NSString stringWithFormat:@"%@-%@", self.poi.city, value.address];
            pointAnnotation.subPOI = (id)value;
            pointAnnotation.poi = self.poi;
        }else {
            pointAnnotation.subtitle = [NSString stringWithFormat:@"%@-%@", value.city, value.address];
            pointAnnotation.poi = value;
        }
        return pointAnnotation;
    }].array;
    [self.mapView addAnnotations:annotations];
    [self.mapView showAnnotations:annotations animated:YES];
}

#pragma mark - Actions

- (IBAction)actionMapTypeChanged:(UISegmentedControl *)sender {
    self.mapView.mapType = sender.selectedSegmentIndex;
}

- (IBAction)actionZoomLevelChanged:(UIStepper *)sender {
    self.mapView.zoomLevel = sender.value;
    self.mapView.cameraDegree = sender.value;
}

- (IBAction)actionCameraDegreeChanged:(UIStepper *)sender {
    self.mapView.cameraDegree = sender.value;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.poiSearchResponse.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = self.poiSearchResponse.pois[indexPath.row].name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableView.hidden = YES;
    
    id<MAAnnotation> annotation = [self.mapView.annotations.rac_sequence filter:^BOOL(id<MAAnnotation> annotation) {
        return annotation.coordinate.latitude == self.poiSearchResponse.pois[indexPath.row].location.latitude
        && annotation.coordinate.longitude == self.poiSearchResponse.pois[indexPath.row].location.longitude;
    }].array.firstObject;
    
    
    [self.mapView setCenterCoordinate:annotation.coordinate animated:NO];
    [self.mapView setZoomLevel:13 animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView deselectAnnotation:self.mapView.selectedAnnotations.firstObject animated:NO];
        [self.mapView selectAnnotation:annotation animated:YES];
    });
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
{
    if (self.searchType == MapSearchTypePOI) {
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        request.keywords            = searchBar.text;
//        request.city                = @"北京";
//        request.types               = @"高等院校";
        request.requireExtension    = YES;
        /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
        request.cityLimit           = YES;
        request.requireSubPOIs      = YES;
        [self.mapSearchAPI AMapPOIKeywordsSearch:request];
    }
    else if (self.searchType == MapSearchTypeAround) {
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location            = self.indexPOI.location;
        request.keywords            = searchBar.text;
        request.radius              = 1000 * 50;
        /* 按照距离排序. */
        request.sortrule            = 0;
        request.requireExtension    = YES;
        request.requireSubPOIs      = YES;
        [self.mapSearchAPI AMapPOIAroundSearch:request];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED;   // called when cancel button pressed
{
    RESIGN_FIRST_RESPONDER;
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED; // called when search results button pressed
{
    self.tableView.hidden = !self.tableView.hidden;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    if (selectedScope == MapSearchTypeAround && !self.indexPOI) {
        [HUDHelper showHudWithDuration:@"请在地图上选择一个点之后再搜索" :2];
        searchBar.selectedScopeButtonIndex = MapSearchTypePOI;
    }
    else if (selectedScope == MapSearchTypePOI) {
        self.indexPOI = nil;
    }
    
    self.searchType = searchBar.selectedScopeButtonIndex;
}

#pragma mark - AMapSearchDelegate
/**
 * @brief 当请求发生错误时，会调用代理的此方法.
 * @param request 发生错误的请求.
 * @param error   返回的错误.
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error;
{
    [HUDHelper showHudWithDuration:error.description :2];
}

/**
 * @brief POI查询回调函数
 * @param request  发起的请求，具体字段参考 AMapPOISearchBaseRequest 及其子类。
 * @param response 响应结果，具体字段参考 AMapPOISearchResponse 。
 */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response;
{
    RESIGN_FIRST_RESPONDER;
    self.poiSearchResponse = response;
    
    self.tableView.hidden = !response.pois.count;
    [self.tableView reloadData];
    [self showPointAnnotationWithPOIs:response.pois];
}

#pragma mark - MAMapViewDelegate

/**
 * @brief 根据anntation生成对应的View。
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    BOOL isUserComtomPointAnnotation = [annotation isEqual:self.userCustomPointAnnotation];
    if ([annotation isKindOfClass:[MACustomPointAnnotation class]]) {
        MACustomPinAnnotationView *annotationView = (MACustomPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(MACustomPinAnnotationView.class)];
        if (!annotationView) {
            annotationView = (MACustomPinAnnotationView *)[[MACustomPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(MACustomPinAnnotationView.class)];
        }
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = isUserComtomPointAnnotation ? YES : NO;
        annotationView.pinColor = isUserComtomPointAnnotation ? MAPinAnnotationColorRed : MAPinAnnotationColorPurple;
        
        UIButton *btnShowInGaodeMap = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnShowInGaodeMap setTitle:@"高德地图展示" forState:UIControlStateNormal];
        [btnShowInGaodeMap sizeToFit];
        annotationView.leftCalloutAccessoryView = btnShowInGaodeMap;
        
        UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = isUserComtomPointAnnotation ? nil : btnDetail;
        
        annotationView.labelName.text = annotation.title;
        annotationView.labelName.textColor = UIColor.redColor;
        
        return annotationView;
    }
    return nil;
}

/**
 * @brief 拖动annotation view时view的状态变化
 * @param mapView 地图View
 * @param view annotation view
 * @param newState 新状态
 * @param oldState 旧状态
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState
   fromOldState:(MAAnnotationViewDragState)oldState;
{
    self.userCustomPointAnnotation.coordinate = view.annotation.coordinate;
    self.indexPOI.location = [AMapGeoPoint locationWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
}

/**
 * @brief 地图缩放结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction;
{
    self.stepperZoomLevel.value = mapView.zoomLevel;
}

/**
 * @brief 当touchPOIEnabled == YES时，单击地图使用该回调获取POI信息
 * @param mapView 地图View
 * @param pois 获取到的poi数组(由MATouchPoi组成)
 */
- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois
{
    
}

/**
 * @brief 当选中一个annotation view时，调用此接口. 注意如果已经是选中状态，再次点击不会触发此回调。取消选中需调用-(void)deselectAnnotation:animated:
 * @param mapView 地图View
 * @param view 选中的annotation view
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view;
{
    
}

/**
 * @brief 当取消选中一个annotation view时，调用此接口
 * @param mapView 地图View
 * @param view 取消选中的annotation view
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view;
{
    
}

/**
 * @brief 标注view的accessory view(必须继承自UIControl)被点击时，触发该回调
 * @param mapView 地图View
 * @param view callout所属的标注view
 * @param control 对应的control
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([control isEqual:view.leftCalloutAccessoryView]) {
        MACustomPointAnnotation *pointAnnotation = view.annotation;
//            iosamap://viewMap?sourceApplication=applicationName&poiname=A&lat=39.98848272&lon=116.47560823&dev=1
        NSURL *myLocationScheme = [NSURL URLWithString:[[NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=zz&poiname=%@&lat=%f&lon=%f&dev=0", pointAnnotation.poi.name, pointAnnotation.poi.location.latitude, pointAnnotation.poi.location.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [[UIApplication sharedApplication] openURL:myLocationScheme options:@{} completionHandler:nil];
    }
    else if ([control isEqual:view.rightCalloutAccessoryView]) {
        AddressDetailViewController *vc = [[AddressDetailViewController alloc] init];
        vc.pointAnnotation = view.annotation;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 * @brief 标注view的calloutview整体点击时，触发该回调。只有使用默认calloutview时才生效。
 * @param mapView 地图的view
 * @param view calloutView所属的annotationView
 */
- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view;
{
    MACustomPointAnnotation *pointAnnotation = view.annotation;
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请选择操作项" cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存位置信息" otherButtonTitles:@[@"标记POI, 用于搜索周边/附近?"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.destructiveButtonIndex) {
            
            LocationTable *info = [LocationTable objectWithClassName:NSStringFromClass(LocationTable.class)];
            [info copyInfoFromPOIInfo:pointAnnotation.poi];
            
            [HUDHelper showHud:@"正在保存位置信息..."];
            [info saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [HUDHelper hideHud];
            }];
        }
        else if (buttonIndex == controller.firstOtherButtonIndex) {
            self.indexPOI = pointAnnotation.poi;
            [HUDHelper showHudWithDuration:@"已标记POI信息, 你可选择附近或周边搜索":2];
        }
    }];
}

/**
 * @brief 标注view被点击时，触发该回调。（since 5.7.0）
 * @param mapView 地图的view
 * @param view annotationView
 */
- (void)mapView:(MAMapView *)mapView didAnnotationViewTapped:(MAAnnotationView *)view;
{
    
}

/**
 * @brief 长按地图，返回经纬度
 * @param mapView 地图View
 * @param coordinate 经纬度
 */
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate;
{
    if (self.userCustomPointAnnotation) {
        [mapView removeAnnotation:self.userCustomPointAnnotation];
    }
    
    self.indexPOI = [[AMapPOI alloc] init];
    self.indexPOI.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    self.indexPOI.name = @"插点位置";
    
    self.userCustomPointAnnotation = [[MACustomPointAnnotation alloc] init];
    self.userCustomPointAnnotation.coordinate = coordinate;
    self.userCustomPointAnnotation.poi = self.indexPOI;
    
    [mapView addAnnotation:self.userCustomPointAnnotation];
    [mapView showAnnotations:@[self.userCustomPointAnnotation] animated:YES];
}

@end
