//
//  UIAlertView+Tools.h
//  Het
//
//  Created by Johnson on 15/3/25.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JShowAlertViewMsg(msg)                          JShowAlertViewMsgCode(msg, nil)
#define JShowAlertViewMsgCode(msg, code)                JShowAlertViewMsgDelay(msg, 1.f, code)
#define JShowAlertViewMsgDelay(msg, s, code)            JShowAlertView(nil, msg, s, code)
#define JShowAlertView(title, msg, s, code)             [UIAlertView showAlert:title message:msg delay:s complete:^{ code; }]

#define JShowAlertViewOk(title, msg)                    [UIAlertView showAlertOk:title message:msg]
#define JShowAlertViewOkMsg(msg)                        JShowAlertViewOk(nil, msg)

@interface UIAlertView (Tools)

/**
 *  显示系统alert.
 *
 *  @param title   标题
 *  @param message 内容
 *
 *  @return <#return value description#>
 */
+ (UIAlertView *)showAlert:(NSString *)title message:(NSString *)message;

/**
 *  显示系统alert. 带确定
 *
 *  @param title   标题
 *  @param message 内容
 *
 *  @return <#return value description#>
 */
+ (UIAlertView *)showAlertOk:(NSString *)title message:(NSString *)message;

/**
 *  显示系统alert.
 *
 *  @param title   标题
 *  @param message 内容
 *  @param delay   延时消失时间
 */
+ (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;

/**
 *  显示系统alert.
 *
 *  @param title   标题
 *  @param message 内容
 *  @param delay   延时消失时间
 *  @param complete 结果回调
 */
+ (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay complete:(void(^)(void))complete;

- (void)show:(void(^)(NSInteger buttonIndex, UIAlertView *alertView))complete;

@end
