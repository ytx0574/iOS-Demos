//
//  PushTools.m
//  Noti
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "PushTools.h"
#import "PusherKit.h"


@interface PushTools ()
+ (instancetype)instance;
+ (NWPusher *)voipPusher;
+ (NWPusher *)remotePusher;
@end

@implementation PushTools
{
    NWPusher *_voipPusher;
    NWPusher *_remotePusher;
}

+ (instancetype)instance;
{
    static PushTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [self new];
    });
    return tools;
}
+ (NWPusher *)voipPusher;
{
    if (![PushTools instance] -> _voipPusher) {
        NSData *pkcs12 = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"push_voip" withExtension:@"p12"]];
        NSError *error = nil;
        [PushTools instance] -> _voipPusher = [NWPusher connectWithPKCS12Data:pkcs12 password:@"1234567" environment:NWEnvironmentSandbox error:&error];
        
        
        if ([PushTools instance] -> _voipPusher) {
            NSLog(@"Connected to APNs");
        } else {
            NSLog(@"Unable to connect: %@", error);
        }
    }
    
    return [PushTools instance]->_voipPusher;
}
+ (NWPusher *)remotePusher;
{
    if (![PushTools instance] -> _remotePusher) {
        NSData *pkcs12 = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"push" withExtension:@"p12"]];
        NSError *error = nil;
        [PushTools instance] -> _remotePusher = [NWPusher connectWithPKCS12Data:pkcs12 password:@"1234567" environment:NWEnvironmentSandbox error:&error];
        
        
        if ([PushTools instance] -> _remotePusher) {
            NSLog(@"Connected to APNs");
        } else {
            NSLog(@"Unable to connect: %@", error);
        }
    }
    
    return [PushTools instance]->_remotePusher;
}



+ (void)pushRemoteNotification:(NSDictionary *)info
                         badge:(NSString *)badge
                         sound:(NSString *)sound
                        isVoIP:(BOOL)isVoIP
                   deviceToken:(NSString *)deviceToken
{
    
    NSString *pushMsg = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    
    
    //去除json中以下符号，否则无法发出推送
    pushMsg = [pushMsg stringByReplacingOccurrencesOfString:@" " withString:@""];
    pushMsg = [pushMsg stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pushMsg = [pushMsg stringByReplacingOccurrencesOfString:@"\"" withString:@"'"]; //双引号转单引号, 解析的时候要转回来的
    
    
    NSString *payload = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"%@\",\"badge\":%@,\"sound\":\"%@\"}}", pushMsg, badge, sound];
//    NSString *payload = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"Testing.. (201)\",\"badge\":1,\"sound\":\"default\"}}"];
    
    NWPusher *pusher = isVoIP ? [PushTools voipPusher] : [PushTools remotePusher];
    
    NSError *error;
    BOOL pushed = [pusher pushPayload:payload token:deviceToken identifier:rand() error:&error];
    if (pushed) {
        NSLog(@"Pushed to APNs");
    } else {
        NSLog(@"Unable to push: %@", error);
    }
}

@end
