//
//  ViewController.m
//  GaodeMap
//
//  Created by Johnson on 2019/8/17.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "SearchOnMapViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItemEdit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItemDelete;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItemDetail;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL edit;

@property (nonatomic, strong) NSArray <AMapPOI *> *arrayWithDataSource;
@property (nonatomic, strong) NSMutableArray <AVObject *> *arrayWithAVObjects;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(TableViewCell.class) bundle:NSBundle.mainBundle] forCellReuseIdentifier:NSStringFromClass(TableViewCell.class)];
    
    @weakify(self)
    [[[RACObserve(self, edit) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.tableView.editing = [x boolValue];
        self.toolBar.hidden = !self.tableView.editing;
        
        self.barButtonItemDelete.enabled = self.tableView.indexPathsForSelectedRows.count;
        self.barButtonItemDetail.enabled = self.barButtonItemDelete.enabled;
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refreshData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)refreshData;
{
    [HUDHelper showHud:nil];
    [[AVQuery queryWithClassName:NSStringFromClass(LocationTable.class)] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [HUDHelper hideHud];
        [self.tableView.mj_header endRefreshing];
        
        self.arrayWithAVObjects = [objects mutableCopy];
        self.arrayWithDataSource = [self.arrayWithAVObjects.rac_sequence map:^id _Nullable(id  _Nullable value) {
            return [LocationTable poiWithAVObject:value];
        }].array;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arrayWithDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    AMapPOI *poi = self.arrayWithDataSource[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.textLabel.text = self.arrayWithDataSource[indexPath.row].name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@%@", poi.province, poi.city, poi.district, poi.address];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    SearchOnMapViewController *vc = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:NSStringFromClass(SearchOnMapViewController.class)];
    vc.pois = @[ self.arrayWithDataSource[indexPath.row] ];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.barButtonItemDelete.enabled = self.tableView.indexPathsForSelectedRows.count;
    self.barButtonItemDetail.enabled = self.barButtonItemDelete.enabled;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
{
    self.barButtonItemDelete.enabled = self.tableView.indexPathsForSelectedRows.count;
    self.barButtonItemDetail.enabled = self.barButtonItemDelete.enabled;
}

#pragma mark - Action

- (IBAction)actionEdit:(UIBarButtonItem *)sender {
    self.edit = !self.edit;
}

- (IBAction)actionSelect:(id)sender {
    NSArray <NSIndexPath *> *aySelectedRows = self.tableView.indexPathsForSelectedRows;
    [self.arrayWithDataSource enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        
        id value = [aySelectedRows.rac_sequence filter:^BOOL(NSIndexPath *value) {
            return value.row == indexPath.row && value.section == indexPath.section;
        }].array.firstObject;
        
        if (value) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        else {
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }];
    
    self.barButtonItemDelete.enabled = self.tableView.indexPathsForSelectedRows.count;
    self.barButtonItemDetail.enabled = self.barButtonItemDelete.enabled;
}

- (IBAction)actionDetail:(id)sender {
    NSArray *ay = [self.tableView.indexPathsForSelectedRows.rac_sequence map:^id _Nullable(NSIndexPath * _Nullable value) {
        return self.arrayWithDataSource[value.row];
    }].array;
    
    SearchOnMapViewController *vc = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:NSStringFromClass(SearchOnMapViewController.class)];
    vc.pois = ay;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionDelete:(id)sender {
    @weakify(self)
    NSArray *ay = [self.tableView.indexPathsForSelectedRows.rac_sequence map:^id _Nullable(NSIndexPath * _Nullable value) {
        return self.arrayWithAVObjects[value.row];
    }].array;
    [LocationTable deleteAllInBackground:ay block:^(BOOL succeeded, NSError * _Nullable error) {
        @strongify(self)
        if (succeeded) {
            self.edit = NO;
            
            [self.arrayWithAVObjects removeObjectsInArray:ay];
            self.arrayWithDataSource = [self.arrayWithAVObjects.rac_sequence map:^id _Nullable(id  _Nullable value) {
                return [LocationTable poiWithAVObject:value];
            }].array;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Get Methods

@end
