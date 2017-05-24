//
//  ViewController.m
//  BackgroundLocation
//
//  Created by Johnson on 2017/5/5.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "DetailVC.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController
{
    NSMutableArray *_mutableArrayDataSourse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Abc new] testAbc];
    
    _mutableArrayDataSourse = [NSMutableArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:@"vc" object:nil];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)updateData:(NSNotification *)noti
{
    self.label.text = noti.object;
    
    [_mutableArrayDataSourse addObject:noti.object];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _mutableArrayDataSourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    cell.textLabel.text = _mutableArrayDataSourse[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    [vc setText:_mutableArrayDataSourse[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    segue.destinationViewController;
}

@end
