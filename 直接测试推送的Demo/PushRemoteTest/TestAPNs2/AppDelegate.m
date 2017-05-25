//
//  AppDelegate.m
//  TestAPNs2
//
//  Created by Johnson on 2017/5/9.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "AppDelegate.h"
#import <PushKit/PushKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSObject+Tools.h"
#import "GetTokenVC.h"

@interface AppDelegate () <NSStreamDelegate, PKPushRegistryDelegate>

@end

@implementation AppDelegate
{
     void(^_expirationHandler)();
    UIBackgroundTaskIdentifier _bgTask;
    UIBackgroundTaskIdentifier _backIden;
    AVAudioPlayer *_player;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.dictionaryRemoteInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:RemoteInfoPath] ?: [NSMutableDictionary dictionary];
    
    if (iOS8AndLater) {
        
        PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
        pushRegistry.delegate = self;
        pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[GetTokenVC new]];
    [self.window makeKeyWindow];
    
    
    
    NSLog(@"launchOptions: %@", launchOptions);
    
    NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    userInfo ? [self hangdleInfo:userInfo isVoIP:NO] : nil;
    
    [self showAlertOk:@"请仔细阅读" message:@"应用外测试:请把本App通知栏所有的消息都点击一遍, 然后再进应用内查看.\n\n\n应用内测试:不用管通知栏的内容, 只需要感受手机震动或者红色文字的变化\n\n\n请点击<复制推送Token到剪切板>, 然后把内容发给发送端"];

    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0);
{
    
    NSString *deviceTokenString = deviceToken.description;
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.stringAPSsToken = deviceTokenString;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0);
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification %@", userInfo);
    
    [self hangdleInfo:userInfo isVoIP:NO];
}

#pragma mark - PushKitDelegate

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type;
{
    if([credentials.token length] == 0)
    {
        NSLog(@"voip token NULL");
        return;
    }
    
    NSString *pushKitTokenString = credentials.token.description;
    pushKitTokenString = [pushKitTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    pushKitTokenString = [pushKitTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    pushKitTokenString = [pushKitTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.stringPushKitToken = pushKitTokenString;
    
    //当token改变时 上报到自己的服务器.
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type;
{

    self.dictionaryRemoteInfo = self.dictionaryRemoteInfo ?: [NSKeyedUnarchiver unarchiveObjectWithFile:RemoteInfoPath] ?: [NSMutableDictionary dictionary];
    
    [self hangdleInfo:payload.dictionaryPayload isVoIP:YES];
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type;
{
    //这里是个可选实现, 当token失效时, 用以通知服务器不再给此设备发送push
}


- (void)hangdleInfo:(NSDictionary *)userInfo isVoIP:(BOOL)isVoIP
{
    
    NSString *sound = userInfo[@"aps"][@"sound"];
    NSString *badge = userInfo[@"aps"][@"badge"];
    NSString *alert = userInfo[@"aps"][@"alert"];
    
    
    alert = [alert stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
    //需要的真实数据内容
    NSMutableDictionary *info = [[NSJSONSerialization JSONObjectWithData:[alert dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil] mutableCopy];
    
    
    if (isVoIP) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.alertBody = [@"PushKit-LocalNotification\n " stringByAppendingString:info.description];
        localNotif.alertAction = info[@"count"];
        localNotif.soundName = sound;
        localNotif.applicationIconBadgeNumber = [badge integerValue];
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }else {
        AudioServicesPlaySystemSound(1007);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
//    @{
//      @"whichTime":@(_whichTime),
//      @"count": @(i),
//      @"totalCount": @(count),
//      };
    
    
    // whichTime 为发送的第几波数据
    NSString *whichTime = info[@"whichTime"];
    NSString *count = info[@"count"];
    NSString *totalCount = info[@"totalCount"];
    
    
    NSMutableArray *array = self.dictionaryRemoteInfo[whichTime] ?: [NSMutableArray array];
    
    NSMutableDictionary *dict = [info mutableCopy];
    [dict setObject:@(isVoIP) forKey:@"VoIP"];
    info = [dict copy];
    
    
    if (![array containsObject:info]) {
        
        [array addObject:info];
        
        [self.dictionaryRemoteInfo setObject:array forKey:whichTime];
        
        [self performInBackground:^{
            [NSKeyedArchiver archiveRootObject:self.dictionaryRemoteInfo toFile:RemoteInfoPath];
        }];
    }
    
    UINavigationController *nvc = self.window.rootViewController;
    [nvc.viewControllers.firstObject performSelector:@selector(refresh)];
    
}


- (void)clearData
{
    [self.dictionaryRemoteInfo removeAllObjects];
    
    [self performInBackground:^{
        [NSKeyedArchiver archiveRootObject:self.dictionaryRemoteInfo toFile:RemoteInfoPath];
    }];
    
    UINavigationController *nvc = self.window.rootViewController;
    [nvc.viewControllers.firstObject performSelector:@selector(refresh)];
}


- (void)copyTokenToPasteboard;
{
    
    if (!self.stringAPSsToken) {
        [self showAlert:nil message:@"请打开推送开关" delay:1];
        return;
    }
    
#ifdef DEBUG
    NSString *environment = @"Debug";
#else
    NSString *environment = @"Release";
#endif
    
    NSDictionary *info = @{
                           @"environment": environment,
                           @"device": [NSString stringWithFormat:@"%@ %@", [NSObject getDeviceType], [NSObject getSystemVersion]],
                           @"stringAPSsToken": self.stringAPSsToken ?: @"",
                           @"stringPushKitToken": self.stringPushKitToken ?: @""
                           };
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSData *dataInfo = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
    pasteboard.string = [[NSString alloc] initWithData:dataInfo encoding:NSUTF8StringEncoding];
    
    [self showAlertOk:pasteboard.string message:@"Token已复制到剪切板, 请使用社交软件转发"];
    NSLog(@"\n%@", pasteboard.string);
}

@end
