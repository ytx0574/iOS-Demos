//
//  UIActionSheet+Tools.m
//  AlertView
//
//  Created by Johnson on 3/25/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import "UIActionSheet+Tools.h"
#import <objc/runtime.h>

@interface UIActionSheet () <UIActionSheetDelegate>

@property (nonatomic, copy) void(^complete)(NSInteger buttonIndex, UIActionSheet *actionSheet);

@end

@implementation UIActionSheet (Tools)

static char ActionSheetCompleteKey;

- (void)showInView:(UIView *)showInView complete:(void(^)(NSInteger buttonIndex, UIActionSheet *actionSheet))complete
{
    self.delegate = self;
    self.complete = complete;
    [self showInView:showInView];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.complete ? self.complete(buttonIndex, actionSheet) : nil;
}

#pragma mark - SetMethods
- (void)setComplete:(void (^)(NSInteger buttonIndex, UIActionSheet *actionSheet))complete
{
    objc_setAssociatedObject(self, &ActionSheetCompleteKey, complete, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - GetMethods
- (void (^)(NSInteger buttonIndex, UIActionSheet *actionSheet))complete
{
    return objc_getAssociatedObject(self, &ActionSheetCompleteKey);
}

@end
