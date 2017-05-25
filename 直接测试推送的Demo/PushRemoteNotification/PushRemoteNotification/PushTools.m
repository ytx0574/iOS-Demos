//
//  PushTools.m
//  Noti
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "PushTools.h"


#warning 配置证书相关内容   注意p12和pl2的区别     这里是一二的一

NSString *voipCerFileName = @"push_voip.p12";
NSString *apnsCerFileName = @"push.p12";

NSString *voipCerPassword = @"1234567";
NSString *apnsCerPassword = @"1234567";



@interface PushTools ()
+ (instancetype)instance;
@end

@implementation PushTools
{
    NWPusher *_voipPusher_sandbox;
    NWPusher *_voipPusher_production;
    
    NWPusher *_remotePusher_sandbox;
    NWPusher *_remotePusher_production;
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


+ (NWPusher *)pusherWithVoip:(BOOL)voip environment:(NWEnvironment)environment;
{
    NWPusher *(^createPusher)(BOOL voip, NWEnvironment environment) = ^NWPusher *(BOOL voip, NWEnvironment environment){

        NSData *pkcs12 = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:voip ? voipCerFileName : apnsCerFileName withExtension:nil]];
        
        NSError *error = nil;
        NWPusher *pusher = [NWPusher connectWithPKCS12Data:pkcs12 password:apnsCerPassword environment:environment error:&error];
        
        if (!pusher || error) {
            NSLog(@"pusher init failed %@ %@", pusher, error);
            return nil;
        }
        
        return pusher;
    };

    PushTools *tools = [PushTools instance];

    if (voip && environment == NWEnvironmentSandbox) {
        
        return tools -> _voipPusher_sandbox ?: (tools -> _voipPusher_sandbox = createPusher(voip, environment));
    }
    else if (voip && environment == NWEnvironmentProduction) {
        
        return tools -> _voipPusher_production ?: (tools -> _voipPusher_production = createPusher(voip, environment));
    }
    else if (!voip && environment == NWEnvironmentSandbox) {
        
        return tools -> _remotePusher_sandbox ?: (tools -> _remotePusher_sandbox = createPusher(voip, environment));
    }
    else if (!voip && environment == NWEnvironmentProduction) {
        
        return tools -> _remotePusher_production ?: (tools-> _remotePusher_production = createPusher(voip, environment));
    }
    
    return nil;
}



+ (void)pushRemoteNotification:(NSDictionary *)info
                         badge:(NSString *)badge
                         sound:(NSString *)sound
                   environment:(NWEnvironment)environment
                        isVoIP:(BOOL)isVoIP
                   deviceToken:(NSString *)deviceToken;
{
    
    NSString *pushMsg = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    
    
    //去除json中以下符号，否则无法发出推送
    pushMsg = [pushMsg stringByReplacingOccurrencesOfString:@" " withString:@""];
    pushMsg = [pushMsg stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pushMsg = [pushMsg stringByReplacingOccurrencesOfString:@"\"" withString:@"'"]; //双引号转单引号, 解析的时候要转回来的
    
    
    NSString *payload = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"%@\",\"badge\":%@,\"sound\":\"%@\"}}", pushMsg, badge, sound];
//    NSString *payload = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"Testing.. (201)\",\"badge\":1,\"sound\":\"default\"}}"];
    
    NWPusher *pusher = [PushTools pusherWithVoip:isVoIP environment:environment];
    
    NSError *error;
    BOOL pushed = [pusher pushPayload:payload token:deviceToken identifier:rand() error:&error];
    if (pushed) {
        NSLog(@"Pushed to APNs");
    } else {
        NSLog(@"Unable to push: %@", error);
    }
}

@end
