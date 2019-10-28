//
//  NSObject+Runtime.m
//  Objective-C
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@interface NSString (Runtime)

+ (NSString *)decodeType:(const char *)cString;

@end

@implementation NSString (Runtime)

+ (NSString *)decodeType:(const char *)cString {
    if (!strcmp(cString, @encode(id))) return @"id";
    if (!strcmp(cString, @encode(void))) return @"void";
    if (!strcmp(cString, @encode(float))) return @"float";
    if (!strcmp(cString, @encode(int))) return @"int";
    if (!strcmp(cString, @encode(BOOL))) return @"BOOL";
    if (!strcmp(cString, @encode(char *))) return @"char *";
    if (!strcmp(cString, @encode(double))) return @"double";
    if (!strcmp(cString, @encode(Class))) return @"class";
    if (!strcmp(cString, @encode(SEL))) return @"SEL";
    
    if (!strcmp(cString, @encode(unsigned long))) return @"unsigned long";
    if (!strcmp(cString, @encode(unsigned int))) return @"unsigned int";
    
    
    NSString *result = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    if ([[result substringToIndex:1] isEqualToString:@"@"] && [result rangeOfString:@"?"].location == NSNotFound) {
        result = [[result substringWithRange:NSMakeRange(2, result.length - 3)] stringByAppendingString:@"*"];
    } else
        if ([[result substringToIndex:1] isEqualToString:@"^"]) {
            result = [NSString stringWithFormat:@"%@ *",
                      [NSString decodeType:[[result substringFromIndex:1] cStringUsingEncoding:NSUTF8StringEncoding]]];
        }
    return result;
}

@end

@implementation NSObject (Runtime)

+ (NSArray *)enumerateIvarsFromClass:(Class)class block:(BOOL(^)(NSUInteger idx, NSString *ivar))block;
{
    unsigned int outCount;
    
    NSMutableArray *ay = [NSMutableArray array];
    
    Ivar *ivars = class_copyIvarList(class, &outCount);
    
    for (NSUInteger i = 0; i < outCount; i++) {
        
        NSString *ivar = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        
        [ay addObject:ivar];
        
        BOOL flag = block ? block(i, ivar) : NO;
        if (flag) { break; }
    }
    
    free(ivars);
    return ay;
}

+ (NSArray *)enumeratePropertiesFromClass:(Class)class block:(BOOL(^)(NSUInteger idx, NSString *property))block;
{
    unsigned int outCount;
    
    NSMutableArray *ay = [NSMutableArray array];
    
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        NSString *property = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        [ay addObject:property];
        
        BOOL flag = block ? block(i, property) : NO;
        if (flag) { break; }
    }
    
    free(properties);
    return ay;
}



- (NSArray *)enumerateIvarsWithBlock:(void(^)(NSUInteger idx, NSString *ivar, BOOL *stop))block;
{
    __block BOOL stop = NO;
    
    return [NSObject enumerateIvarsFromClass:[self class] block:^BOOL(NSUInteger idx, NSString *ivar) {
        
        if (!stop) {block ? block(idx, ivar, &stop) : nil;}
        
        return stop;
    }];
    
}

- (NSArray *)enumeratePropertiesWithBlock:(void(^)(NSUInteger idx, NSString *property, BOOL *stop))block;
{
    __block BOOL stop = NO;
    
    return [NSObject enumeratePropertiesFromClass:[self class] block:^BOOL(NSUInteger idx, NSString *property) {
        
        if (!stop) {block ? block(idx, property, &stop) : nil;}
        
        return stop;
    }];
    
}

+ (NSArray *)runtimeSubClasses
{
    Class *buffer = NULL;
    
    int count, size;
    do
    {
        count = objc_getClassList(NULL, 0);
        buffer = (Class *)realloc(buffer, count * sizeof(*buffer));
        size = objc_getClassList(buffer, count);
    } while(size != count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i < count; i++)
    {
        Class candidate = buffer[i];
        Class superclass = candidate;
        while(superclass)
        {
            if(superclass == self)
            {
                [array addObject: candidate];
                break;
            }
            superclass = class_getSuperclass(superclass);
        }
    }
    free(buffer);
    return array;
}

- (NSArray *)runtimeSubClasses
{
    return [[self class] runtimeSubClasses];
}


+ (NSString *)runtimeParentClassHierarchy
{
    NSMutableString *result = [NSMutableString string];
    getSuper([self class], result);
    return result;
}

- (NSString *)runtimeParentClassHierarchy
{
    return [[self class] runtimeParentClassHierarchy];
}


+ (NSArray *)runtimeClassMethods
{
    return [self methodsForClass:object_getClass([self class]) typeFormat:@"+"];
}

- (NSArray *)runtimeClassMethods
{
    return [[self class] runtimeClassMethods];
}


+ (NSArray *)runtimeInstanceMethods
{
    return [self methodsForClass:[self class] typeFormat:@"-"];
}

- (NSArray *)runtimeInstanceMethods
{
    return [[self class] runtimeInstanceMethods];
}


+ (NSArray *)runtimeProtocols
{
    unsigned int outCount;
    Protocol * const *protocols = class_copyProtocolList([self class], &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        unsigned int adoptedCount;
        Protocol * const *adotedProtocols = protocol_copyProtocolList(protocols[i], &adoptedCount);
        NSString *protocolName = [NSString stringWithCString:protocol_getName(protocols[i]) encoding:NSUTF8StringEncoding];
        
        NSMutableArray *adoptedProtocolNames = [NSMutableArray array];
        for (int idx = 0; idx < adoptedCount; idx++) {
            [adoptedProtocolNames addObject:[NSString stringWithCString:protocol_getName(adotedProtocols[idx]) encoding:NSUTF8StringEncoding]];
        }
        NSString *protocolDescription = protocolName;
        
        if (adoptedProtocolNames.count) {
            protocolDescription = [NSString stringWithFormat:@"%@ <%@>", protocolName, [adoptedProtocolNames componentsJoinedByString:@", "]];
        }
        [result addObject:protocolDescription];
        //free(adotedProtocols);
    }
    //free((__bridge void *)(*protocols));
    return result.count ? [result copy] : nil;
}

- (NSArray *)runtimeProtocols
{
    return [[self class] runtimeProtocols];
}

- (NSString *)memoryAddress;
{
    return [NSString stringWithFormat:@"%p", self];
}

#pragma mark - RuntimePrivate

static void getSuper(Class class, NSMutableString *result)
{
    [result appendFormat:@" -> %@", NSStringFromClass(class)];
    if ([class superclass]) { getSuper([class superclass], result); }
}

+ (NSArray *)methodsForClass:(Class)class typeFormat:(NSString *)type {
    unsigned int outCount;
    Method *methods = class_copyMethodList(class, &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        NSString *methodDescription = [NSString stringWithFormat:@"%@ (%@)%@",
                                       type,
                                       [NSString decodeType:method_copyReturnType(methods[i])],
                                       NSStringFromSelector(method_getName(methods[i]))];
        
        NSInteger args = method_getNumberOfArguments(methods[i]);
        NSMutableArray *selParts = [[methodDescription componentsSeparatedByString:@":"] mutableCopy];
        NSInteger offset = 2; //1-st arg is object (@), 2-nd is SEL (:)
        
        for (int idx = (int)offset; idx < args; idx++) {
            NSString *returnType = [NSString decodeType:method_copyArgumentType(methods[i], idx)];
            selParts[idx - offset] = [NSString stringWithFormat:@"%@:(%@)arg%d",
                                      selParts[idx - offset],
                                      returnType,
                                      idx - 2];
        }
        [result addObject:[selParts componentsJoinedByString:@" "]];
    }
    free(methods);
    return result.count ? [result copy] : nil;
}
@end

