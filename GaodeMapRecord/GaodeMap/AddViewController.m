//
//  AddViewController.m
//  GaodeMap
//
//  Created by Johnson on 2019/8/23.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "AddViewController.h"
#import "SearchOnMapViewController.h"

@interface AddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLat;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLon;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SearchOnMapViewController class]]) {
        CONVERT_INTANCE_TYPE(SearchOnMapViewController, segue.destinationViewController).defatultSearchText = self.textFieldName.text;
    }
}

@end
