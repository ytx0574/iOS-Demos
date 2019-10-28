//
//  UIView+Tools.m
//  Xt
//
//  Created by Johnson on 31/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "UIView+Tools.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIView (Tools)

- (void)addTapGestureToResignFirstResponderComplete:(void(^)(UIView *view))complete;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        complete ? complete(self) : nil;
    }];
    [self addGestureRecognizer:tap];
}
@end
