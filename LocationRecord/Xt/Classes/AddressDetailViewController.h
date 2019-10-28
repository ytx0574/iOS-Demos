//
//  AddressDetailViewController.h
//  Xt
//
//  Created by Johnson on 23/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AddressDetailViewController : BaseViewController

@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic, strong) CLPlacemark *placemark;

@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewAddress;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@end
