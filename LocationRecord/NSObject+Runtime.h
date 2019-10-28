//
//  NSObject+Runtime.h
//  Objective-C
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

/**
 *  获取class所有的ivar
 *
 *  @param class class
 *  @param block 获取字段时的循环回调, stop为YES, block不再回调, 停止循环
 *
 *  @return class的ivar数组
 */
+ (NSArray *)enumerateIvarsFromClass:(Class)class block:(BOOL(^)(NSUInteger idx, NSString *ivar))block;

/**
 *  获取class所有的property
 *
 *  @param class class
 *  @param block 获取字段时的循环回调, stop为YES, block不再回调, 停止循环
 *
 *  @return class的property数组
 */
+ (NSArray *)enumeratePropertiesFromClass:(Class)class block:(BOOL(^)(NSUInteger idx, NSString *property))block;

/**
 *  获取当前对象所有的ivar
 *
 *  @param block 获取字段时的循环回调, stop为YES, block不再回调, 停止循环
 *
 *  @return 当前对象的ivar数组
 */
- (NSArray *)enumerateIvarsWithBlock:(void(^)(NSUInteger idx, NSString *ivar, BOOL *stop))block;

/**
 *  获取当前对象所有的property
 *
 *  @param block 获取字段时的循环回调, stop为YES, block不再回调, 停止循环
 *
 *  @return 当前对象的property数组
 */
- (NSArray *)enumeratePropertiesWithBlock:(void(^)(NSUInteger idx, NSString *property, BOOL *stop))block;

/**
 *  获取当前所有子类
 *
 *  @return 所有子类
 */
+ (NSArray *)runtimeSubClasses;
- (NSArray *)runtimeSubClasses;

/**
 *  获取父类
 *
 *  @return 父类对象字符串
 */
+ (NSString *)runtimeParentClassHierarchy;
- (NSString *)runtimeParentClassHierarchy;

/**
 *  获取当前类的类方法
 *
 *  @return 类方法字符串
 */
+ (NSArray *)runtimeClassMethods;
- (NSArray *)runtimeClassMethods;

/**
 *  获取当前类的实例方法
 *
 *  @return 实例方法字符串
 */
+ (NSArray *)runtimeInstanceMethods;
- (NSArray *)runtimeInstanceMethods;

/**
 *  获取当前类实现的所有协议
 *
 *  @return 实现的协议字符串
 */
+ (NSArray *)runtimeProtocols;
- (NSArray *)runtimeProtocols;
@end

