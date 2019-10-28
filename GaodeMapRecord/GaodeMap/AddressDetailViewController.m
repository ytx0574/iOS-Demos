//
//  AddressDetailViewController.m
//  GaodeMap
//
//  Created by Johnson on 2019/8/26.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "MWPhotoBrowser.h"
#import "SearchOnMapViewController.h"

@interface AddressDetailViewController () <UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *> *arrayWithTitles;
@end

@implementation AddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayWithTitles = @[
                             ///名称
                             @keypath(self.pointAnnotation.poi, name),
                             ///兴趣点类型
                             @keypath(self.pointAnnotation.poi, type),
                             ///省
                             @keypath(self.pointAnnotation.poi, province),
                             ///城市名称
                             @keypath(self.pointAnnotation.poi, city),
                             ///区域名称
                             @keypath(self.pointAnnotation.poi, district),
                             ///地址
                             @keypath(self.pointAnnotation.poi, address),
                             ///所在商圈
                             @keypath(self.pointAnnotation.poi, businessArea),
                             ///扩展信息只有在ID查询时有效
                             @keypath(self.pointAnnotation.poi, extensionInfo),
                             ///子POI列表
                             @keypath(self.pointAnnotation.poi, subPOIs),
                             ///图片列表
                             @keypath(self.pointAnnotation.poi, images),
                             
                             ///POI全局唯一ID
                             @keypath(self.pointAnnotation.poi, uid),
                             ///类型编码
                             @keypath(self.pointAnnotation.poi, typecode),
                             ///经纬度
                             @keypath(self.pointAnnotation.poi, location),
                             ///电话
                             @keypath(self.pointAnnotation.poi, tel),
                             ///距中心点的距离，单位米。在周边搜索时有效
                             @keypath(self.pointAnnotation.poi, distance),
                             ///停车场类型，地上、地下、路边
                             @keypath(self.pointAnnotation.poi, parkingType),
                             ///商铺id
                             @keypath(self.pointAnnotation.poi, shopID),
                             ///邮编
                             @keypath(self.pointAnnotation.poi, postcode),
                             ///网址
                             @keypath(self.pointAnnotation.poi, website),
                             ///电子邮件
                             @keypath(self.pointAnnotation.poi, email),
                             ///省编码
                             @keypath(self.pointAnnotation.poi, pcode),
                             ///城市编码
                             @keypath(self.pointAnnotation.poi, citycode),
                             ///区域编码
                             @keypath(self.pointAnnotation.poi, adcode),
                             ///地理格ID
                             @keypath(self.pointAnnotation.poi, gridcode),
                             ///入口经纬度
                             @keypath(self.pointAnnotation.poi, enterLocation),
                             ///出口经纬度
                             @keypath(self.pointAnnotation.poi, exitLocation),
                             ///方向
                             @keypath(self.pointAnnotation.poi, direction),
                             ///是否有室内地图
                             @keypath(self.pointAnnotation.poi, hasIndoorMap),
                             ///室内信息
                             @keypath(self.pointAnnotation.poi, indoorData),

                             ];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arrayWithTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    id value = [self.pointAnnotation.poi valueForKey:self.arrayWithTitles[indexPath.row]];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.textLabel.text = self.arrayWithTitles[indexPath.row];
    cell.detailTextLabel.text = [value description];
    
    if ([value isKindOfClass:AMapIndoorData.class]) {
        cell.detailTextLabel.text = CONVERT_INTANCE_TYPE(AMapIndoorData, value).floorName;
    }
    else if ([value isKindOfClass:AMapPOIExtension.class]) {
        AMapPOIExtension *extension = value;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"评分:%@, 人均消费:%@, 营业时间:%@", @(extension.rating), @(extension.cost), extension.openTime];
    }
    else if ([value isKindOfClass:NSArray.class]) {
        if ([value count] == 0) {
            cell.detailTextLabel.text = @"无数据";
        }
        else if ([[value firstObject] isKindOfClass:AMapSubPOI.class]) {
            cell.detailTextLabel.text = [[[value rac_sequence] map:^id _Nullable(AMapSubPOI *value) {
                return [value.name stringByAppendingFormat:@"-%@米", @(value.distance)];
            }].array componentsJoinedByString:@"|"];
        }
        else if ([[value firstObject] isKindOfClass:AMapImage.class]) {
            cell.detailTextLabel.text = [@([value count]).stringValue stringByAppendingString:@"张"];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    id value = [self.pointAnnotation.poi valueForKey:self.arrayWithTitles[indexPath.row]];

    if ([value isKindOfClass:NSArray.class] && [value count] == 0) {
        UIAlertController *vc = [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"暂无数据" cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
        [vc performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:nil afterDelay:1];
    }
    else if ([[value firstObject] isKindOfClass:AMapSubPOI.class]) {
        SearchOnMapViewController *vc = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:NSStringFromClass(SearchOnMapViewController.class)];
        vc.poi = self.pointAnnotation.poi;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([[value firstObject] isKindOfClass:AMapImage.class]) {
        MWPhotoBrowser *photoBrowseVC = [[MWPhotoBrowser alloc] initWithDelegate:self];
        photoBrowseVC.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
        photoBrowseVC.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        photoBrowseVC.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        photoBrowseVC.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        photoBrowseVC.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        photoBrowseVC.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        photoBrowseVC.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        photoBrowseVC.autoPlayOnAppear = NO; // Auto-play first video
        
        // Customise selection images to change colours if required
        photoBrowseVC.customImageSelectedIconName = @"ImageSelected.png";
        photoBrowseVC.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
        
        [self.navigationController pushViewController:photoBrowseVC animated:YES];
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser;
{
    return self.pointAnnotation.poi.images.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
{
    return [MWPhoto photoWithURL:[NSURL URLWithString:self.pointAnnotation.poi.images[index].url]];
}

//@optional
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;
//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;
//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser;

@end
