//
//  GetTokenVC.m
//  TestAPNs2
//
//  Created by Johnson on 2017/5/23.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "GetTokenVC.h"
#import "AppDelegate.h"
#import "NSObject+Tools.h"
#import "DetailRemoteInfoVC.h"


#define SortedKeys  \
[DictionaryRemoteInfo.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {\
return [obj2 integerValue] > [obj1 integerValue] ? NSOrderedDescending : NSOrderedAscending;\
}]\


@interface GetTokenVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTips;
@end

@implementation GetTokenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTips.text = [NSString stringWithFormat:@"共收到%@批数据", @(DictionaryRemoteInfo.count)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清理数据" style:UIBarButtonItemStylePlain target:AppDelegateInstance action:@selector(clearData)];
    self.navigationItem.rightBarButtonItem = rightItem;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickGetToken:(id)sender {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] copyTokenToPasteboard];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return SortedKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:KCellIndentifier];
    }
    
    //key number
    NSString *key = SortedKeys[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%@批数据", key];
    
    NSDictionary *firstInfo = [DictionaryRemoteInfo[key] firstObject];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"类型:%@, 发送%@次, 收到%@次", [firstInfo[@"VoIP"] boolValue] ? @"VoIP" : @"APNs", firstInfo[@"totalCount"], @([DictionaryRemoteInfo[key] count])];
    
    cell.detailTextLabel.textColor = [UIColor redColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *key = SortedKeys[indexPath.row];
    
    [self.navigationController pushViewController:[[DetailRemoteInfoVC alloc] initWithIndex:[key integerValue] remoteInfo:DictionaryRemoteInfo[key]] animated:YES];
}

- (void)refresh
{
    self.labelTips.text = [NSString stringWithFormat:@"共收到%@批数据", @(DictionaryRemoteInfo.count)];
    [self.tableView reloadData];
}

@end
