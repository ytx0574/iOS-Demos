//
//  EncodeModel.m
//  Noti
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "EncodeModel.h"
#import <objc/runtime.h>

@implementation EncodeModel

- (void)enumeratePropertiesWithBlock:(void(^)(NSString *key))block
{
    unsigned int outCount;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        
        block ? block(key) : nil;
        
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    __weak typeof(self) wself = self;
    [self enumeratePropertiesWithBlock:^(NSString *key) {
        [aCoder encodeObject:[wself valueForKey:key] forKey:key];
    }];
    
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    if (self = [super init]) {
        
        __weak typeof(self) wself = self;
        [self enumeratePropertiesWithBlock:^(NSString *key) {
            [wself setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }];
    }
    return self;
}

@end
