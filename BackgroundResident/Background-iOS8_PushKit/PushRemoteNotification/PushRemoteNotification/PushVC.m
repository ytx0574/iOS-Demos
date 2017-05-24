//
//  PushVC.m
//  PushRemoteNotification
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "PushVC.h"
#import "PushTools.h"

@interface PushVC ()

@property (weak, nonatomic) IBOutlet UILabel *labelIPadToken;
@property (weak, nonatomic) IBOutlet UILabel *labelIPhoneToken;
@end

@implementation PushVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self testSend100];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)testSend100
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        for (int i = 0; i < 60; i++) {
            
            NSDictionary *dict = @{
                                   @"count": @(i),
                                   @"sendtime": @([[NSDate date] timeIntervalSince1970]),
                                   };
            
            
            //air2
            [PushTools pushRemoteNotification:dict
                                        badge:@"1"
                                        sound:@"default"
                                       isVoIP:YES
                                  deviceToken:@"e504a6cb3fb2c0f1e87aaf598f8eceb0399d8f88920ed8977c9220a6e5a3d874"];
            
            //iphone5
            [PushTools pushRemoteNotification:dict
                                        badge:@"1"
                                        sound:@"default"
                                       isVoIP:YES
                                  deviceToken:@"993c6ff2967965166e67dd716bc436822486fddb26fff28dcbb7ffe19c32a0b3"];
            
            NSLog(@"这是发送%@次VoIP_Push", @(i));
            sleep(1);
        }
        
    });
}






- (IBAction)clickSend100:(id)sender {
    
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    [self testSend100];
}










- (IBAction)clickPushVoIPIPad:(id)sender {
    [PushTools pushRemoteNotification:@{@"kk": @"mm"}
                                badge:@"1"
                                sound:@"default"
                               isVoIP:YES
                          deviceToken:@"e504a6cb3fb2c0f1e87aaf598f8eceb0399d8f88920ed8977c9220a6e5a3d874"];
}

// l 1
- (IBAction)clickPushIPad:(id)sender {
    
    [PushTools pushRemoteNotification:@{@"app_push": @"mm"}
                                badge:@"2"
                                sound:@"default"
                       isVoIP:NO
                          deviceToken:@"893d25c724785d021a07abdb4a1f7f722b626bd86df683d05cedc697ae20a2e2"];
}


- (IBAction)clickPushVoIPIPhone:(id)sender {
    
    [PushTools pushRemoteNotification:@{@"count": @(0), @"sendtime": @(1494579299.808022)}
                                badge:@"1"
                                sound:@"default"
                               isVoIP:YES
                          deviceToken:@"993c6ff2967965166e67dd716bc436822486fddb26fff28dcbb7ffe19c32a0b3"];
}


- (IBAction)clickPushIPhone:(id)sender {
    [PushTools pushRemoteNotification:@{@"app_push": @"mm"}
                                badge:@"2"
                                sound:@"default"
                               isVoIP:NO
                          deviceToken:@"abd592f3e0a8591bea2280ce0d1765072a9c55f16ce33ab9c140c26ab0dcea83"];
}

@end
