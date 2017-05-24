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


#warning ------------------------------参考文章: http://blog.csdn.net/openglnewbee/article/details/44807191---------------------------------------------------------


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
    
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    

//    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
//    
//    sleep(2);
//    
//    CGFloat x = [[NSDate date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:interval]];
    
    
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0);
{
    
    NSString *deviceTokenString = deviceToken.description;
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceToken %@", deviceTokenString);

    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = deviceTokenString;
    
    [[[UIAlertView alloc] initWithTitle:nil message:deviceTokenString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0);
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification %@", userInfo);

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}


#pragma mark - StreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
{

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
    
    NSLog(@"pushKitToken %@", pushKitTokenString);
    
    
    //当token改变时 上报到自己的服务器.
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type;
{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.alertBody = [NSString stringWithFormat:@"Incoming Call. PushKit_LocalNotification"];
    localNotif.alertAction = NSLocalizedString(@"Accept Call", nil);
    localNotif.soundName = @"alarmsound.caf";
    localNotif.applicationIconBadgeNumber = 11;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    
    [self playMusic];

    
    NSLog(@"-----------------------------------------------voip----------------------------------------------------------------");
    
    
//    sleep(30);
    
    
    NSArray *ay = @[@"xx", @"456456"];
    BOOL flag = [ay writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/ay"] atomically:YES];
    
    
    
//    self.window = self.window ?: [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    self.window.backgroundColor = [UIColor blackColor];
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController = [UIViewController new];
//    
//    NSLog(@"-----------------------------------------------%d %@ %@----------------------------------------------------------------", flag, NSHomeDirectory(), self.window);
//    
//
//    
//    UILabel *label100record = [self.window viewWithTag:100];
//    if (label100record == nil) {
//        label100record = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 111, 111)];
//        label100record.textColor = [UIColor redColor];
//        label100record.tag = 100;
//        [self.window addSubview:label100record];
//    }
//    
//    NSUInteger count = [[label100record.text stringByReplacingOccurrencesOfString:@"100次测试完了之后, 收到的次数:" withString:@""] intValue];
//    label100record.text = [NSString stringWithFormat:@"100次测试完了之后, 收到的次数:%@", @(count + 1)];
    
    
    
    self.arrayDataSourse = self.arrayDataSourse ?: [NSMutableArray array];
    
    
    NSString *msg = payload.dictionaryPayload[@"aps"][@"alert"];
    msg = [msg stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
    NSMutableDictionary *info = [[NSJSONSerialization JSONObjectWithData:[msg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil] mutableCopy];
    
    [info setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"recvtime"];
    
    [self.arrayDataSourse addObject:info];
    
    [self.window.rootViewController performSelector:@selector(update)];
    
    
    //我只能说真的很强大, 如果你的App没有打开, 那么这里相当于后台悄悄启动了这个App, 并且可以做任何事;
    //当应用已经打开时, 也可以做任何事.    但是最好不要在这里做过多的业务操作. 逻辑都能写死你!!!
    
    
    //如果连本地通知逻辑都省略了之后, 用户不会感觉到程序有任何反应, 而实际程序有最多30s的执行时间(这里仅仅测试iPhone5 iOS10.2, 以sleep的城市休眠, 仅供参考- -), 程序其实已经后台运行了, 并且不会出现在多任务管理器中.  (流氓保活..)
    
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type;
{
    //这里是个可选实现, 当token失效时, 用以通知服务器不再给此设备发送push
}

- (void)playMusic
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    
    NSLog(@"KKKKKKKKKKKKKKKKKKKKKKKKKKK              %@", session);
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //播放背景音乐
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"南征北战 - 生来倔强" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    NSLog(@"KKKKKKKKKKKKKKKKKKKKKKKKKKK              url%@", url);
    
    //    // 创建播放器
    [_player stop];
    _player = nil;
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_player prepareToPlay];
    [_player setVolume:1];//完全无声
    _player.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    [_player play]; //播放
    
}









//_expirationHandler = ^{
//
//    [application endBackgroundTask:_bgTask];
//    _bgTask = UIBackgroundTaskInvalid;
//    
//    
//    _bgTask = [application beginBackgroundTaskWithExpirationHandler:_expirationHandler];
//};
//
//_bgTask = [application beginBackgroundTaskWithExpirationHandler:_expirationHandler];
//
//
//// Start the long-running task and return immediately.
//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    
//    while (1) {
//        sleep(7);
//        //NSLog(@"BGTime left: %f", [UIApplication sharedApplication].backgroundTimeRemaining);
//        
//        if (TRUE) {
//            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//            if (localNotif) {
//                localNotif.alertBody = [NSString stringWithFormat:@"Incoming Call."];
//                localNotif.alertAction = NSLocalizedString(@"Accept Call", nil);
//                localNotif.soundName = @"alarmsound.caf";
//                localNotif.applicationIconBadgeNumber = 11;
//                [application presentLocalNotificationNow:localNotif];
//            }
//        }
//    }
//});

@end
