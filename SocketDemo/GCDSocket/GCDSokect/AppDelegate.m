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
{
    NSMutableData *_inputStreamReceiveData;
}
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


//此处手动截获CFReadStreamRef的数据, CCDAsyncSocket本身有回调, 这里再次取出测试;
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
{
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
        {
            NSLog(@"NSStreamEventOpenCompleted-- 连接成功");
        }
            break;
        case NSStreamEventHasBytesAvailable:
        {
            NSLog(@"NSStreamEventHasBytesAvailable-- read data");
            
            uint8_t buffer[1024];
            NSInteger length = [(NSInputStream *)aStream read:buffer maxLength:sizeof(buffer)];
            
            //记录当前消息, 此处如果一条消息一次读不完, 会分几次返回该方法.
            _inputStreamReceiveData ? [_inputStreamReceiveData appendBytes:buffer length:length] : (_inputStreamReceiveData = [NSMutableData dataWithBytes:(const void *)buffer length:length]);
            
            NSString *msg = [[NSString alloc] initWithData:_inputStreamReceiveData encoding:NSUTF8StringEncoding];
            
            //当没有下一条消息时, 输出日志并释放对象;
            if (![(NSInputStream *)aStream hasBytesAvailable]) {
                
                ShowLocalNotificationAndIfMsgIs963PerformExit3(msg);
                //                [self testPerform]; //测试后台执行时间
                
                //不用之后及时释放掉
                @autoreleasepool {
                    _inputStreamReceiveData = nil;
                    msg = nil;
                }
                
            }
        }
            break;
            
        case NSStreamEventHasSpaceAvailable:
        {
            NSLog(@"NSStreamEventHasSpaceAvailable-- write data");
        }
            break;
            
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"NSStreamEventErrorOccurred-- 连接错误");
        }
            break;
        case NSStreamEventEndEncountered:
        {
            NSLog(@"NSStreamEventEndEncountered--  连接断开或关闭");
        }
            break;
            
        default:
        {
            NSLog(@"NSStreamEventNone--");
        }
            break;
    }

}


@end
