//
//  UIAlertView+Tools.m
//  Het
//
//  Created by Johnson on 15/3/25.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import "UIAlertView+Tools.h"
#import <objc/runtime.h>

@interface UIAlertView () <UIAlertViewDelegate>
@property (nonatomic, copy) void(^complete)(NSInteger buttonIndex, UIAlertView *alertView);
@end

@implementation UIAlertView (Tools)

static char AlertViewCompleteKey;

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    self.complete ? self.complete(buttonIndex, alertView) : nil;
}

#pragma mark - SetMethods

- (void)setComplete:(void (^)(NSInteger buttonIndex, UIAlertView *alertView))complete
{
    objc_setAssociatedObject(self, &AlertViewCompleteKey, complete, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - GetMethods

- (void(^)(NSInteger buttonIndex, UIAlertView *alertView))complete
{
    return objc_getAssociatedObject(self, &AlertViewCompleteKey);
}

#pragma mark - PublicMethods

- (void)show:(void(^)(NSInteger buttonIndex, UIAlertView *alertView))complete
{
    self.delegate = self;
    self.complete = complete;
    [self show];
}

+ (UIAlertView *)showAlert:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
}

+ (UIAlertView *)showAlertOk:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
}

+ (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;
{
    UIAlertView *alertView = [self showAlert:title message:message];
    [alertView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:delay];
}

+ (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay complete:(void(^)(void))complete;
{
    [self showAlert:title message:message delay:delay];
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            complete ? complete() : nil;
        });
    });
}

@end
