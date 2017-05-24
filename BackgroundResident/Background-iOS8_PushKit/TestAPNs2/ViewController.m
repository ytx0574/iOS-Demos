//
//  ViewController.m
//  TestAPNs2
//
//  Created by Johnson on 2017/5/9.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "EncodeModel.h"
#import "InfoCell.h"

static NSString *kCellIndentifier = @"InfoCell";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *label_send_recv_timeinterval_average;

@property (weak, nonatomic) IBOutlet UILabel *label_send_recv_timeinterval_max;
@property (weak, nonatomic) IBOutlet UILabel *label_last_recv_timeinterval_max;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *arrayWithDataSourse;
@end

@implementation ViewController
{
    CGFloat _send_recv_timeinterval_max;
    CGFloat _send_recv_timeinterval_average;
    CGFloat _last_recv_timeinterval_max;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InfoCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellIndentifier];
    
    [self update];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arrayWithDataSourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIndentifier];

    EncodeModel *model = self.arrayWithDataSourse[indexPath.row];
    cell.labelInfo.text = [NSString stringWithFormat:@"收到的内容:%@\n发送与接收的时间间隔:%@\n与上次接收的时间间隔:%@", model.info, @(model.send_recv_timeinterval), @(model.last_recv_timeinterval)];
    
    if (model.last_recv_timeinterval == _last_recv_timeinterval_max) {
        
        cell.labelInfo.textColor = self.label_last_recv_timeinterval_max.textColor;
        
    }else {
        
        cell.labelInfo.textColor = [UIColor blackColor];
        
    }
    
    
    if (model.send_recv_timeinterval == _send_recv_timeinterval_max) {
        
        cell.labelInfo.textColor = self.label_send_recv_timeinterval_max.textColor;
        
     }else {
         
         cell.labelInfo.textColor = [UIColor blackColor];
         
     }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 188;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}


- (void)update
{
    self.arrayWithDataSourse = self.arrayWithDataSourse ?: [@[] mutableCopy];
    [self.arrayWithDataSourse removeAllObjects];
    
    __block CGFloat sum_send_recv_interval = 0.f;
    NSArray *ay = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).arrayDataSourse;
    [ay enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *recv_date = [NSDate dateWithTimeIntervalSince1970:[obj[@"recvtime"] longLongValue]];
        NSDate *send_date = [NSDate dateWithTimeIntervalSince1970:[obj[@"sendtime"] longLongValue]];
        NSDate *last_recv_date = idx == 0 ? nil : [NSDate dateWithTimeIntervalSince1970:[ay[idx - 1][@"recvtime"] longLongValue]];
        
        EncodeModel *model = [EncodeModel new];
        model.info = obj;
        model.send_recv_timeinterval = [recv_date timeIntervalSinceDate:send_date];
        model.last_recv_timeinterval = idx == 0 ? 0 : [recv_date timeIntervalSinceDate:last_recv_date];
        
        [self.arrayWithDataSourse addObject:model];
        
        sum_send_recv_interval += model.send_recv_timeinterval;
        
        
        _send_recv_timeinterval_max = model.send_recv_timeinterval > _send_recv_timeinterval_max ? model.send_recv_timeinterval : _send_recv_timeinterval_max;
        
        _last_recv_timeinterval_max = model.last_recv_timeinterval > _last_recv_timeinterval_max ? model.last_recv_timeinterval : _last_recv_timeinterval_max;
        
    }];
    
    self.label_last_recv_timeinterval_max.textColor = [UIColor blueColor];
    self.label_send_recv_timeinterval_max.textColor = [UIColor redColor];
    
    
    self.labelCount.text = [@"接收次数:" stringByAppendingString:@(ay.count).stringValue];
    self.label_send_recv_timeinterval_average.text = [@"收发平均间隔:" stringByAppendingString:@(sum_send_recv_interval / ay.count).stringValue];
    
    self.label_send_recv_timeinterval_max.text = [@"收发最大间隔:" stringByAppendingString:@(_send_recv_timeinterval_max).stringValue];
    self.label_last_recv_timeinterval_max.text = [@"前后最大间隔:" stringByAppendingString:@(_last_recv_timeinterval_max).stringValue];
    
    [self.tableView reloadData];

}

@end
