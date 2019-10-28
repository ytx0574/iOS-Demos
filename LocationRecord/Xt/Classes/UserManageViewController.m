//
//  UserManageViewController.m
//  Xt
//
//  Created by Johnson on 30/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "UserManageViewController.h"
#import "Header.h"
#import "AppInfo.h"

@interface UserManageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@end

@implementation UserManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户管理";
    
    @weakify(self);
    RAC(self.buttonLogin, enabled) = RAC(self.buttonRegister, enabled) = [[RACSignal combineLatest:@[self.textFieldUserName.rac_textSignal, self.textFieldPassword.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        @strongify(self)
        return @( self.textFieldUserName.text.length != 0 && self.textFieldPassword.text.length != 0 );
    }];
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

- (IBAction)clickLogin:(id)sender {
    [SVProgressHUD show];
    [AppInfo loginWithUserName:self.textFieldUserName.text password:self.textFieldPassword.text complete:^(BOOL isSuccessful, NSArray *array, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (!isSuccessful) {
                JShowAlertViewMsg(error.description);
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }];
}

- (IBAction)clickRegister:(id)sender {
    [SVProgressHUD show];
    [AppInfo registerUser:self.textFieldUserName.text password:self.textFieldPassword.text complete:^(BOOL isSuccessful, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (!isSuccessful) {
                JShowAlertViewMsg(error.description);
            }else {
                JShowAlertViewMsg(@"注册成功, 请点击登录");
            }
        });

    }];
}

@end
