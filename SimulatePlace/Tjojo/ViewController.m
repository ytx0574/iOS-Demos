//
//  ViewController.m
//  Tjojo
//
//  Created by Johnson on 2019/8/4.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "TZLocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)action:(id)sender {
    
    [[TZLocationManager manager] startLocationWithSuccessBlock:nil failureBlock:^(NSError *error) {
        
    } geocoderBlock:^(NSArray <CLPlacemark *> *geocoderArray) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:geocoderArray.firstObject.description preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }];
}

@end
