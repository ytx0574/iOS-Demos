//
//  NSObject+CallBack.m
//  TestP
//
//  Created by jsonlong on 16/4/20.
//  Copyright © 2016年 zsgf. All rights reserved.
//

#import "NSObject+CallBack.h"
#import <objc/runtime.h>

@interface NSObject()

@end

@implementation NSObject (CallBack)

static char CallBackKey;
- (void)setCallBack:(void (^)())callBack
{
    objc_setAssociatedObject(self, &CallBackKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())callBack
{
    return objc_getAssociatedObject(self, &CallBackKey);
}


@end
