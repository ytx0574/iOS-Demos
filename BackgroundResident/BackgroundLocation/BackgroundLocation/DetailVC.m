//
//  DetailVC.m
//  BackgroundLocation
//
//  Created by Johnson on 2017/5/5.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "DetailVC.h"

@interface DetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (void)setText:(NSString *)text
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.label.text = text;
    });
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



@implementation Abc
{
    NSInteger _flag;
}

- (void)testAbc;
{
    
    
    NSString *str = @"https://125.69.90.110:1010/svn/crisisgo_ios_refactor/documents/iOS%20Cer%20APNs%E3%80%81HTTP:2%20APNs%E5%88%86%E6%9E%90/";
    str = [str stringByReplacingPercentEscapesUsingEncoding:4];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int idx = 0; idx < 100; idx++) {
            _flag--;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (int idx = 0; idx < 101; idx++) {
            _flag++;
        }
    });
    
    
    [self performSelector:@selector(putFlag) withObject:nil afterDelay:3];
}


- (void)putFlag
{
    _flag;
    
}

@end
