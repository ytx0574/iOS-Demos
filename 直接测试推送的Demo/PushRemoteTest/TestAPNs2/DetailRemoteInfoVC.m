//
//  DetailRemoteInfoVC.m
//  TestAPNs2
//
//  Created by Johnson on 2017/5/24.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "DetailRemoteInfoVC.h"
#import "NSObject+Tools.h"
#import "DetailRemoteCell.h"

@interface DetailRemoteInfoVC ()
@property (strong, nonatomic) NSArray *arrayRemoteInfo;
@property (assign, nonatomic) NSUInteger index;


@property (weak, nonatomic) IBOutlet UILabel *labelTips;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DetailRemoteInfoVC

- (instancetype)initWithIndex:(NSUInteger)index remoteInfo:(NSArray *)array
{
    self = [super init];
    if (self) {
        _arrayRemoteInfo = array;
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailRemoteCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:KCellIndentifier];
    
    NSUInteger totalCount = [self.arrayRemoteInfo.firstObject[@"totalCount"] integerValue];
    NSUInteger recvCount = self.arrayRemoteInfo.count;
    
    self.labelTips.text = [NSString stringWithFormat:@"第%@批推送, 发送:%@次, 收到%@次", @(self.index), @(totalCount), @(recvCount)];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arrayRemoteInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DetailRemoteCell *cell = [tableView dequeueReusableCellWithIdentifier:KCellIndentifier];
    
    //    @{
    //      @"whichTime":@(_whichTime),
    //      @"count": @(i),
    //      @"totalCount": @(count),
    //      };
    
    NSDictionary *info = self.arrayRemoteInfo[indexPath.row];
    
    // whichTime 为发送的第几波数据
    NSString *whichTime = info[@"whichTime"];
    NSString *count = info[@"count"];
    NSString *totalCount = info[@"totalCount"];
    
    
    cell.labelNumber.text = count;

    NSData *data = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
    cell.labelDetail.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
