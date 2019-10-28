//
//  AddressDetailViewController.m
//  Xt
//
//  Created by Johnson on 23/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "Header.h"
#import "AppInfo.h"
#import "UIView+Tools.h"

@interface AddressDetailViewController ()

@end

@implementation AddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isAdd ? @"添加位置" : @"查看位置";
    
    @weakify(self);
    RAC(self.buttonAdd, enabled) = [[RACSignal combineLatest:@[self.textFieldTitle.rac_textSignal, self.textViewAddress.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        @strongify(self)
        return @( self.textFieldTitle.text.length != 0 && self.textViewAddress.text.length != 0 );
    }];
    
    self.buttonAdd.hidden = !self.isAdd;
    self.textFieldTitle.enabled = self.isAdd;
    self.textViewAddress.editable = self.isAdd;
    
    [self.view addTapGestureToResignFirstResponderComplete:nil];
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

- (IBAction)clickAdd:(id)sender {
    IF_RETURN(self.textFieldTitle.text.length == 0, JShowAlertViewMsg(@"请填写标题"));
    IF_RETURN(self.textViewAddress.text.length == 0, JShowAlertViewMsg(@"请填写文字内容"));
    
    
    BmobObject *insert = [BmobObject objectWithClassName:kBmobTableName_UserLocation];
    [AppInfo getUser:^(BmobUser *user) {
        [insert setObject:user.objectId forKey:kBmobKey_userLocation_userObjectId];
        [insert setObject:self.textFieldTitle.text forKey:kBmobKey_userLocation_addressName];
        [insert setObject:[NSString stringWithFormat:@"%@,%@", @(self.placemark.location.coordinate.latitude), @(self.placemark.location.coordinate.longitude)] forKey:kBmobKey_userLocation_addressLocation];
        [insert setObject:self.textViewAddress.text forKey:kBmobKey_userLocation_addressDetail];
        
        [SVProgressHUD showWithStatus:@"正在提交"];
        @weakify(self)
        [insert saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            @strongify(self)
            [SVProgressHUD dismiss];
            if (isSuccessful) {
                JShowAlertViewMsg(@"添加成功");
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                JShowAlertViewOkMsg(error.description);
            }
        }];
    }];
}
@end
