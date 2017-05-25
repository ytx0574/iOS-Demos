
//  NSObject+AFNetworking.m
//  mat
//
//  Created by Johnson on 14-6-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NSObject+Tools.h"
#pragma mark - 获取设备型号使用
#include "sys/types.h"
#include "sys/sysctl.h"
#pragma mark - 获取对象信息使用
#import <objc/message.h>


#pragma mark - 辅助方法
#define DES_ENCRYPT_KEY @"DES_ENCRYPT_KEY"
@implementation NSObject (Accessibility)

- (UIAlertView *)showAlert:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
}

- (UIAlertView *)showAlertOk:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
}

- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;
{
    UIAlertView *alertView = [self showAlert:title message:message];
    [alertView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:delay];
}

- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay complete:(void(^)())complete;
{
    [self showAlert:title message:message delay:delay];
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            complete ? complete() : nil;
        });
    });
}

@end


#pragma mark - 设备信息
@implementation NSObject (UIDeviceType)

+ (NSString *)getDeviceType{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE (A1662/A1723/A1724)";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (A1660/A1779/A1780)";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (A1661/A1785/A1786)";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (A1778)";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus(A1784)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G (A1574)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini2 (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini2 (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini2 (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini3 (A1601)";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini4 (A1550)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air2 (A1566)";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini4 (A1550)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air2 (A1567)";
    
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7-inch) (A1673)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7-inch) (A1674/A1675)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9-inch) (A1584)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9-inch) (A1652)";
    if ([platform isEqualToString:@"iPad6,11"])   return @"iPad (5th generation) (A1822)";
    if ([platform isEqualToString:@"iPad6,12"])   return @"iPad (5th generation) (A1823)";
    
    if ([platform isEqualToString:@"Watch1,1"])   return @"Apple Watch (A1553)";
    if ([platform isEqualToString:@"Watch1,2"])   return @"Apple Watch (A1554/A1638)";
    if ([platform isEqualToString:@"Watch2,6"])   return @"Apple Watch (A1802)";
    if ([platform isEqualToString:@"Watch2,7"])   return @"Apple Watch (A1803)";
    if ([platform isEqualToString:@"Watch2,3"])   return @"Apple Watch (A1757/A1816)";
    if ([platform isEqualToString:@"Watch2,4"])   return @"Apple Watch (A1758/A1817)";

    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G (A1378)";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3G (A1427)";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3G (A1469)";
    if ([platform isEqualToString:@"AppleTV5,3"])   return @"Apple TV 4G (A1625)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString *)getSystemVersion;
{
    return [[UIDevice currentDevice] systemVersion];
}

@end

#pragma mark - 获取对象的信息
@implementation NSObject (Thread)

- (void)performInBackground:(void(^)(void))backgroundCode
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        backgroundCode ? backgroundCode() : nil;
    });
}

- (void)performOnMainThread:(void(^)(void))mainCode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        mainCode ? mainCode() : nil;
    });
}

- (void)performInBackground:(void(^)(void))backgroundCode onMainThread:(void(^)(void))mainCode
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        backgroundCode ? backgroundCode() : nil;
//        dispatch_async(dispatch_get_main_queue(), ^{
            mainCode ? mainCode() : nil;
//        });
    });
}
@end
