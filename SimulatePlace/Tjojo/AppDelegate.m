//
//  AppDelegate.m
//  Tjojo
//
//  Created by Johnson on 2019/8/4.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "AppDelegate.h"
@import CoreLocation;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    __NSXPCInterfaceProxy_CLSimulationXPCServerInterface;
    

//    NSXPCConnection *connection = [[NSXPCConnection alloc] performSelector:@selector(initWithServiceName:) withObject:@"com.apple.locationd.simulation"];
    
    
    
//    Class class = NSClassFromString(@"CLSimulationManager");
//    id simulation = [[class alloc] init];
//    
//    NSArray <NSString *> *availableScenarios = [simulation performSelector:NSSelectorFromString(@"availableScenarios") withObject:nil];
//    id connection = [simulation performSelector:NSSelectorFromString(@"connection") withObject:nil];
//    id daemonProxy = [simulation performSelector:NSSelectorFromString(@"daemonProxy") withObject:nil];
//    NSString *scenariosPath = [simulation performSelector:NSSelectorFromString(@"scenariosPath") withObject:nil];
//    
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[scenariosPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", availableScenarios.firstObject]]];
//    
//    NSData *data =  [dict[@"Locations"] firstObject];
//    [data writeToFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/xt.txt"] atomically:YES];
//    
//    [@"" writeToFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/Documents.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    [@"" writeToFile:[NSHomeDirectory() stringByAppendingString:@"/Library/Library.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    [@"" writeToFile:[NSHomeDirectory() stringByAppendingString:@"/SystemData/SystemData.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:108.782123 longitude:108.782123];
//    [simulation performSelector:NSSelectorFromString(@"simulateSignificantLocationChange:") withObject:location];
//    [simulation performSelector:NSSelectorFromString(@"startLocationSimulation") withObject:nil];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


@end
