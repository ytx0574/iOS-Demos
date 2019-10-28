//
//  HUDHelper.h
//  EG
//
//  Created by jsonlong on 16/4/22.
//  Copyright © 2016年 zsgf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HUDHelper : NSObject

//+ (UIWindow *) mainWindow;
//+ (AppDelegate *)delegate;
/**
 *  在main_queue中执行 queue block
 *
 *  @param queue queue
 */
+ (void)runInMainQueue:(void (^)(void))queue;

/**
 *  在global_queue中执行 queue block
 *
 *  @param queue queue
 */
+ (void)runInGlobalQueue:(void (^)(void))queue;

+ (void)showHud:(NSString *)message inView:(UIView *)view;
+ (void)showHudWithDuration:(NSString *)message :(double)delay;
+ (void)showHudWithDuration:(NSString *)message __attribute__((deprecated("Use +toast: instead")));
+ (void)hideHudFromView:(UIView*)view;
+ (void)toast:(NSString *)message;
+ (void)toast:(NSString *)message block:(void (^)(void))block;
+ (void)toastLongMessage:(NSString *)message block:(void (^)(void))block;
+ (void)showHud:(NSString *)message;
+ (void)hideHud;

@end
