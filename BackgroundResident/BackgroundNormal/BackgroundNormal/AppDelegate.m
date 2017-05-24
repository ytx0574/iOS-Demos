//
//  AppDelegate.m
//  BackgroundNormal
//
//  Created by Johnson on 2017/5/4.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSTimer *_timer;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"___________________________________________________\n%f\n", [[UIApplication sharedApplication] backgroundTimeRemaining]);
    
    NSLog(@"___________________________________________________\n%@\n", [NSDate date]);
    
    
    
    [_timer invalidate];
    _timer = nil;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(applicationDidEnterBackground:) userInfo:nil repeats:YES];

    __block NSUInteger number = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"___________________________________________________\n%@\n", [NSDate date]);
        
        [[UIApplication sharedApplication] endBackgroundTask:number];
    
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(applicationDidEnterBackground:) userInfo:nil repeats:YES];
    }];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

@end
