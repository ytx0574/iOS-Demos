//
//  AppDelegate.m
//  GCDSokect
//
//  Created by Johnson on 2017/5/18.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Defines.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    ViewController *vc = ((ViewController *)self.window.rootViewController);
 
    BOOL  backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600  handler:^ {
        NSLog(@"GCDSokect-------------------------------------------------开启VoIP后台!! %d", [vc.sokectClient enableBackgroundingOnSocket]);
    }];
    
    if (backgroundAccepted)
    {
        NSLog(@"GCDSokect-------------------------------------------------VOIP backgrounding accepted");
    }
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


#pragma mark - Delegate


//此处手动截获CFReadStreamRef的数据, iOS7可以收到, 而iOS10无任何反应.
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
{
    
    if ([aStream isKindOfClass:[NSInputStream class]]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            uint8_t buffer[1024];  //此处如果一条消息一次读不完, 会分几次返回该方法.
            NSInteger length = [(NSInputStream *)aStream read:buffer maxLength:sizeof(buffer)];
            
          
            NSData *data = [NSData dataWithBytes:(const void *)buffer length:length];
            NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            ShowLocalNotificationAndIfMsgIs963PerformExit3(msg);
            NSLog(@"--托管消息");
        });
        
    }
    
}


@end
