//
//  AppDelegate.m
//  BackgroundResideDemo
//
//  Created by Johnson on 2017/5/4.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
@import AVFoundation;

@interface AppDelegate () <UISplitViewControllerDelegate>
{
    NSInteger aa;
    NSTimer *_timer;
    UIBackgroundTaskIdentifier _backIden;
    AVAudioPlayer *_player;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [UIWindow new];
    self.window.rootViewController = [MasterViewController new];
    [self.window makeKeyAndVisible];
    
    
    
//    [self playMusic];
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

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}


















- (void)playMusic
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    

    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //播放背景音乐
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"南征北战 - 生来倔强" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
//    // 创建播放器
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_player prepareToPlay];
    [_player setVolume:0.0];//完全无声
    _player.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    [_player play]; //播放
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(go:) userInfo:nil repeats:YES];
}






- (void)applicationDidEnterBackground:(UIApplication *)application {
//    aa =0;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(go:) userInfo:nil repeats:YES];
    
    NSTimeInterval interval = [[UIApplication sharedApplication] backgroundTimeRemaining];
    printf("%f \n", interval);
    
    [self playMusic];
    
    
//    NSLog(@"进入后台的时间:  %@", [NSDate date]);
//    
//    __weak typeof(self) wself = self;
//    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        NSLog(@"开始执行任务:  %@", [NSDate date]);
//        [[UIApplication sharedApplication] endBackgroundTask:_backIden];
//        [wself applicationDidEnterBackground:application];
//    }];
}




-(void)go:(NSTimer *)tim
{
    aa++;
    NSLog(@"BackgroundResideDemo      %@ %@  %@", NSStringFromSelector(_cmd), @(aa), [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 8]);

}




-(void)beginTask
{
    NSLog(@"begin=============");
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"begin  bgend=============");
        [self endBack]; // 如果在系统规定时间内任务还没有完成，在时间到之前会调用到这个方法，一般是10分钟
    }];
}

-(void)endBack
{
    NSLog(@"end=============");
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

@end
