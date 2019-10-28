//
//  AddressListViewController.m
//  Xt
//
//  Created by Johnson on 23/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "AddressListViewController.h"
#import "Header.h"
#import "AppInfo.h"
#import "UIActionSheet+Tools.h"

#import "AddressDetailViewController.h"
#import "OpenMap.h"

@interface AddressListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <BmobObject *> *arrayWithDatasourse;
@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"位置列表";
    self.tableView.tableFooterView = [UIView new];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:kBmobTableName_UserLocation];
    [AppInfo getUser:^(BmobUser *user) {
        [bquery whereKey:kBmobKey_userLocation_userObjectId equalTo:user.objectId];
        
        [SVProgressHUD showWithStatus:@"正在获取数据"];
        @weakify(self)
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            @strongify(self)
            [SVProgressHUD dismiss];
            self.arrayWithDatasourse = [array mutableCopy];
            [self.tableView reloadData];
        }];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arrayWithDatasourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    cell.textLabel.text = [self.arrayWithDatasourse[indexPath.row] objectForKey:kBmobKey_userLocation_addressName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    AddressDetailViewController *vc = INSTANCEFROMMAINWITHCLASS([AddressDetailViewController class]);
    @weakify(vc)
    @weakify(self)
    vc.viewDidLoadComplete = ^{
        @strongify(vc)
        @strongify(self)
        vc.isAdd = NO;
        vc.textFieldTitle.text = [self.arrayWithDatasourse[indexPath.row] objectForKey:kBmobKey_userLocation_addressName];
        vc.textViewAddress.text = [self.arrayWithDatasourse[indexPath.row] objectForKey:kBmobKey_userLocation_addressDetail];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    NSString *locationStr = [self.arrayWithDatasourse[indexPath.row] objectForKey:kBmobKey_userLocation_addressLocation];
    NSString *lat = [locationStr componentsSeparatedByString:@","].firstObject;
    NSString *lon = [locationStr componentsSeparatedByString:@","].lastObject;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择地图" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果地图", @"谷歌地图", @"百度地图", @"高德地图", nil];
    [actionSheet showInView:self.view complete:^(NSInteger buttonIndex, UIActionSheet *actionSheet) {
        
        if (buttonIndex > 3) { return ; }
        
        MapType type = buttonIndex == 0 ? MapTypeApple : buttonIndex == 1 ? MapTypeGoogle : buttonIndex == 2 ? MapTypeBaidu : buttonIndex == 3 ? MapTypeGaode : MapTypeNone;
        [OpenMap openMapWithType:type coordinate:coordinate complete:^(NSError *error) {
            JShowAlertViewMsg(@"未安装该应用");
        }];
    }];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED;
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [SVProgressHUD showWithStatus:@"正在删除"];
    @weakify(self)
    [self.arrayWithDatasourse[indexPath.row] deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        @strongify(self)
        
        [SVProgressHUD dismiss];
        if (isSuccessful) {
            [self.arrayWithDatasourse removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else {
            JShowAlertViewOkMsg(error.description);
        }
    }];
}

@end
