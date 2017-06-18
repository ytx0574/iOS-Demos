//
//  NSObject+AFNetworking.h
//  mat
//
//  Created by Johnson on 14-6-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define KCellIndentifier @"identifier"

#define iOS8AndLater            ([UIDevice currentDevice].systemVersion.floatValue >= 8)

#define RemoteInfoPath          [NSHomeDirectory() stringByAppendingString:@"/Documents/remoteinfo"]


#define AppDelegateInstance     (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define DictionaryRemoteInfo    [AppDelegateInstance dictionaryRemoteInfo]


#pragma mark - 辅助方法
@interface NSObject (Accessibility)

/**
 *  显示系统alert.
 *
 *  @param title   标题
 *  @param message 内容
 *
 *  @return <#return value description#>
 */
- (UIAlertView *)showAlert:(NSString *)title message:(NSString *)message;

/**
 *  显示系统alert. 带确定
 *
 *  @param title   标题
 *  @param message 内容
 *
 *  @return <#return value description#>
 */
- (UIAlertView *)showAlertOk:(NSString *)title message:(NSString *)message;

/**
 *  显示系统alert.
 *
 *  @param title   标题
 *  @param message 内容
 *  @param delay   延时消失时间
 */
- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  显示系统alert.
 *
 *  @param title   标题
 *  @param message 内容
 *  @param delay   延时消失时间
 *  @param complete 结果回调
 */
- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay complete:(void(^)())complete;

@end


#pragma mark - 获取当前设备名称
@interface NSObject (UIDeviceType)

/**
 *  获取当前设备的名称 http://theiphonewiki.com/wiki/Models
 *
 *  @return 返回设备名称
 */
+ (NSString *)getDeviceType;
/**
 *  获取当前系统版本
 *
 *  @return 返回系统版本号
 */
+ (NSString *)getSystemVersion;

@end


@interface NSObject (Thread)
/**
 *  后台执行
 *
 *  @param backgroundCode 后台执行的代码
 */
- (void)performInBackground:(void(^)(void))backgroundCode;
/**
 *  主线程执行
 *
 *  @param mainCode 主线程执行代码
 */
- (void)performOnMainThread:(void(^)(void))mainCode;
/**
 *  后台执行之后转前台
 *
 *  @param backgroundCode 后台执行的代码
 *  @param mainCode       主线程执行代码
 */
- (void)performInBackground:(void(^)(void))backgroundCode onMainThread:(void(^)(void))mainCode;

@end
