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

@property (weak, nonatomic) IBOutlet UITextField *textSendCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentEnvironment;
@end

@implementation PushVC
{
    NSUInteger _whichTime;
    NSMutableArray *_apnsTokens;
    NSMutableArray *_pushKitTokens;
    NWEnvironment _environment;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _whichTime = [[[NSUserDefaults standardUserDefaults] valueForKey:@"_whichTime"] integerValue];
    _environment = NWEnvironmentSandbox;
    
    _pushKitTokens = [NSMutableArray array];
    _apnsTokens = [NSMutableArray array];

    [self.segmentEnvironment addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self valueChanged:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)valueChanged:(UISegmentedControl *)seg
{
    _environment = seg.selectedSegmentIndex == 0 ? NWEnvironmentSandbox : NWEnvironmentProduction;
    
    [_apnsTokens removeAllObjects];
    [_pushKitTokens removeAllObjects];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_environment == NWEnvironmentSandbox ? @"sandbox_tokens" : @"production_tokens" ofType:@"plist"]];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *stringPushKitToken = obj[@"stringPushKitToken"];
        NSString *stringAPSsToken = obj[@"stringAPSsToken"];
        
        ![stringPushKitToken isEqualToString:@""] ? [_pushKitTokens addObject:stringPushKitToken] : nil;
        
        ![stringAPSsToken isEqualToString:@""] ? [_apnsTokens addObject:stringAPSsToken] : nil;
        
    }];
    
}


//所有token 发送N次 APNs推送
- (void)apnsPushWithCount:(NSUInteger)count tokens:(NSArray *)tokens
{

    [self pushWithCount:count tokens:tokens isVoIP:NO];

}

//所有token 发送N次 PushKit推送
- (void)pushKitWithCount:(NSUInteger)count tokens:(NSArray *)tokens
{
    [self pushWithCount:count tokens:tokens isVoIP:YES];
    
}



- (void)pushWithCount:(NSUInteger)count tokens:(NSArray *)tokens isVoIP:(BOOL)isVoIP
{
    _whichTime++;
    
    for (int i = 1; i <= count; i++) {
    
        NSDictionary *info = @{
                               @"whichTime":@(_whichTime).stringValue,
                               @"count": @(i).stringValue,
                               @"totalCount": @(count).stringValue,
                               };
        
        [tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [PushTools pushRemoteNotification:info
                                        badge:@(i).stringValue
                                        sound:@"default"
                                  environment:_environment
                                       isVoIP:isVoIP
                                  deviceToken:obj];
            
        }];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(_whichTime) forKey:@"_whichTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}





- (IBAction)clickSendAPNs:(id)sender {
    if (self.textSendCount.text.integerValue <= 0) {
        return;
    }
    
    [self apnsPushWithCount:self.textSendCount.text.integerValue tokens:_apnsTokens];
}

- (IBAction)clickSendVoIP:(id)sender {
    if (self.textSendCount.text.integerValue <= 0) {
        return;
    }
    
    [self pushKitWithCount:self.textSendCount.text.integerValue tokens:_pushKitTokens];
}


- (IBAction)clickSendAll:(id)sender {
    if (self.textSendCount.text.integerValue <= 0) {
        return;
    }
    
    [self apnsPushWithCount:self.textSendCount.text.integerValue tokens:_apnsTokens];
    [self pushKitWithCount:self.textSendCount.text.integerValue tokens:_pushKitTokens];
}

@end
