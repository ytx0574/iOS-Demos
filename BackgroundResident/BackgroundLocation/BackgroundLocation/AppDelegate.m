//
//  AppDelegate.m
//  BackgroundLocation
//
//  Created by Johnson on 2017/5/5.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "AppDelegate.h"
@import CoreLocation;

@interface AppDelegate () <CLLocationManagerDelegate>

@end

@implementation AppDelegate
{
    CLLocationManager *_locationManager;
    NSTimer *_timer;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    

//    if ([UIDevice currentDevice].systemVersion.floatValue > 7) {
//        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
//            [[[UIAlertView alloc] initWithTitle:nil message:@"定位权限未开启" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
//        }
//    }else {
//        if (![CLLocationManager locationServicesEnabled]) {
//            [[[UIAlertView alloc] initWithTitle:nil message:@"定位权限未开启" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
//        }
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}











- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [_locationManager requestAlwaysAuthorization];

    [_locationManager stopUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self startLocation];
}




- (void)startLocation
{
    _locationManager = _locationManager ?: [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.delegate = self;
//    [_locationManager allowDeferredLocationUpdatesUntilTraveled:500 timeout:30];
    if ([UIDevice currentDevice].systemVersion.floatValue > 8.0) {
        [_locationManager requestAlwaysAuthorization];
    }
    [_locationManager startUpdatingLocation];
    
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printTimer:) userInfo:nil repeats:YES];
}


- (void)printTimer:(NSTimer *)timer
{
    NSLog(@"==============---------------------------=============BackgroundLocation  %@ %@", NSStringFromSelector(_cmd), timer);
}


#pragma CLLocaitonManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0) __TVOS_PROHIBITED __WATCHOS_PROHIBITED;
{
    NSLog(@"===========================BackgroundLocation  %@ %@", NSStringFromSelector(_cmd), newLocation);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
{
    NSLog(@"===========================BackgroundLocation  %@ %@", NSStringFromSelector(_cmd), locations);

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"vc" object:locations.lastObject.description];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    NSLog(@"===========================BackgroundLocation  %@ %@", NSStringFromSelector(_cmd), error);

}

@end
