//
//  AppDelegate.m
//  iOS_Socket
//
//  Created by Johnson on 21/04/2017.
//  Copyright © 2017 Johnson. All rights reserved.
//

#import "AppDelegate.h"
#import "Defines.h"

@interface AppDelegate ()
{
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    UIBackgroundTaskIdentifier _identifier;
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
    
    //启动程序就开启系统VoIP托管
    [self openVoIPStream];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0);
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken %@", deviceToken);
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
    
//    [_inputStream close];
//    [_outputStream close];
//
//    //关闭系统托管 重连socket
//    [((UINavigationController *)self.window.rootViewController).viewControllers.firstObject performSelector:@selector(reconnectSocket)];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


/**测试能后台执行多少秒, 未执行完的内容下次会继续执行*/
- (void)testPerform
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        for (int i = 0; i < 33; i++) {
            NSLog(@"测试后台执行时间 %@s", @(i));
            sleep(1);
        }
        
    });
}

/**VoIP开启系统托管*/
- (void)openVoIPStream;
{
    #warning 系统VoIP托管的流需要每次都重新创建, 注意内存释放问题. ip和端口都通过Deifines常量配置;
    
    
        
    [_inputStream close];
    [_outputStream close];
    
    _inputStream = nil;
    _outputStream = nil;
    
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)[[NSURL URLWithString:kIp] host], kPort, &readStream, &writeStream);
    
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    
    
    [_inputStream setDelegate:(id)self];
    [_inputStream setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
    
    [_outputStream setDelegate:(id)self];
    [_outputStream setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    [self openVoIPStream];

    __weak typeof(self) wself = self;
   BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:606 handler:^(void)
     {
         //超时后主动开启
         [wself openVoIPStream];
         NSLog(@"iOS_Socket-------------------------------------------------开启VoIP后台!!");

     }];
    if (backgroundAccepted)
    {
        NSLog(@"iOS_Socket-------------------------------------------------VOIP backgrounding accepted");
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //
    [self openVoIPStream];
}

#pragma mark - Delegate

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
