//
//  NSObject+AFNetworking.h
//  mat
//
//  Created by Johnson on 14-6-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 辅助方法
@interface NSObject (Accessibility)

/**
 *  根据字典的值获取键
 *
 *  @param dicationary dicationary
 *  @param value       value
 *
 *  @return key
 */
+ (id)getKeyFromDicatinary:(NSDictionary *)dicationary value:(id)value;

/**
 *  转换HTTP返回的数据中的一些键
 *
 *  @param responseObject 请求返回的数据
 *  @param keys           需要转换的键  例如(默认值):@{@"\"id\"": @"\"idUbing\""} 把返回数据里面的键id变成idUbing(包含"")
 *
 *  @return 转换后的数据NSData
 */
+ (id)convertResponseObject:(id)responseObject keys:(NSDictionary *)keys;

/**
 *  得到model跟服务器不同的字段(取出两个array里面的不同的数据)
 *
 *  @param array1
 *  @param array2
 */
- (NSArray *)getDifferentObjectForArray:(NSArray *)array1 array2:(NSArray *)array2;

/**
 *  为Model赋值操作
 *
 *  @param info 传入的info
 *
 *  @return 返回创建并赋值的Model
 */
+ (instancetype)initWithDictionary:(NSDictionary *)info;

/**
 *  为model赋值操作
 *
 *  @param info 传入的info
 */
- (void)setUpWithDictionary:(NSDictionary *)info;

/**
 *  更具一个对象给当前对象赋值
 *
 */
- (void)copyProperty:(id)info;
/**
 *  延时执行代码
 *
 *  @param delay    时间
 *  @param complete <#complete description#>
 */
- (void)delayPerform:(NSTimeInterval)delay complete:(void (^)(void))complete;

/**
 *  进行对字符串进行des加密
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
- (NSData *)encrypt:(NSString *)string;

/**
 *  对加密后的字符串进行des解密
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)decrypt:(NSData *)data;

/**
 *  根据类生成字典. |属性 key, 值 value|  (主要用于请求参数的转换)
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)modelConvertDictionary;

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

#pragma mark - Runtime
@interface NSObject (Runtime)

/**
 *  获取当前所以子类
 *
 *  @return return value description
 */
+ (NSArray *)runtimeSubClasses;
- (NSArray *)runtimeSubClasses;

/**
 *  获取父类
 *
 *  @return <#return value description#>
 */
+ (NSString *)runtimeParentClassHierarchy;
- (NSString *)runtimeParentClassHierarchy;

/**
 *  获取当前类的类方法
 *
 *  @return <#return value description#>
 */
+ (NSArray *)runtimeClassMethods;
- (NSArray *)runtimeClassMethods;

/**
 *  获取当前类的实例方法
 *
 *  @return <#return value description#>
 */
+ (NSArray *)runtimeInstanceMethods;
- (NSArray *)runtimeInstanceMethods;

/**
 *  或者实例大小
 *
 *  @return <#return value description#>
 */
+ (size_t)runtimeInstanceSize;
- (size_t)runtimeInstanceSize;

/**
 *  或取当前类所以属性
 *
 *  @return <#return value description#>
 */
+ (NSArray *)runtimeProperties;
- (NSArray *)runtimeProperties;

/**
 *  获取当前类实现的所有协议
 *
 *  @return <#return value description#>
 */
+ (NSArray *)runtimeProtocols;
- (NSArray *)runtimeProtocols;

/**
 *  获取某个对象所有实例方法
 *
 *  @param class 对象类型
 *
 *  @return <#return value description#>
 */
- (NSArray *)instanceMethodList:(Class)tClass;
/**
 *  获取某个对象的所有实例变量
 *
 *  @param class <#class description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)ivarList:(Class)tClass;
/**
 *  获取某个对象的所有属性
 *
 *  @param class <#class description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)propertyList:(Class)tClass;
/**
 *  获取某个对象的所有实例变量及值
 *
 *  @param class <#class description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableDictionary *)getAllIvarAndVelues:(Class)tClass;
/**
 *  获取某个对象的所有属性及值
 *
 *  @param class <#class description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableDictionary *)getAllPropertiesAndVaules:(Class)tClass;
/**
 *  根据值获取属性名称
 *
 *  @param value <#value description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)getPropertyNameForValue:(id)value;
/**
 *  log对象属性信息
 *
 *  @param showPropertyValue 显示属性值
 */
- (NSString *)Log:(BOOL)showPropertyValue;

@end

#pragma mark - 文件管理
@interface NSObject (FileManager)

/**
 *  创建目录
 *
 *  @param path                  目录路径
 *
 *  @return YES成功,NO失败
 */
+ (BOOL)createDirectory:(NSString *)path;

/**
 *  创建文件
 *
 *  @param path 文件路径
 *  @param data 文件内容
 *
 *  @return YES成功,NO失败
 */
+ (BOOL)createFile:(NSString *)path Content:(NSData *)data;

/**
 *  判断是文件还是目录
 *
 *  @param path 路径
 *
 *  @return YES文件,NO目录
 */
+ (BOOL)isFile:(NSString *)path;

/**
 *  判断指定路径是否存在
 *
 *  @param  路径
 *
 *  @return YES存在,NO不存在
 */
+ (BOOL)isExistsAtPath:(NSString *)path;

/**
 *  删除指定路径文件
 *
 *  @param path 路径
 *
 *  @return YES成功,NO失败
 */
+ (BOOL)removeFile:(NSString *)path;

/**
 *  删除指定路径目录
 *
 *  @param path 路径
 *
 *  @return YES成功,NO失败
 */
+ (BOOL)removeDirectory:(NSString *)path;

//创建文件夹  返回路径
/**
 *  创建文件夹(Documents创建)
 *
 *  @param dirName 
 *
 *  @return 返回文件夹路径
 */
+ (NSString *)createDirectoryOnDocuments:(NSString *)dirName;

@end

#pragma mark - 对时间的操作
@interface NSObject (Time)

+ (NSDateFormatter *)getDateFormatter;

/**
 *  得到当前时间的字符串(如:type 0:返回 20130828153322  type 1:返回 2013-08-28 15:33:22  2:返回 2013-08-28  3:返回 2013年8月28日 15时33分22秒 4:返回2013年8月28日)
 *
 *  @param type 时间字符串类型
 *
 *  @return 当前时间字符串
 */
- (NSString *)getNowDateForall:(NSInteger)type;

/**
 *  与当前时间做比较  返回(几个月前,几周前,几天前,几小时前,几分钟前,几秒前)
 *
 *  @param date 被比较的时间
 *
 *  @return 返回相差时间字符串(如:1个月前,1天前)
 */
- (NSString *)intervalFromLastDate:(NSDate *) date;

/**
 *  根据当前时间生成字符串.(保存文件可以使用)
 *
 *  @param suffix 文件后缀名
 *
 *  @return 生成的文件名
 */
- (NSString *)getNowDateFileName:(NSString *)suffix;

/**
 *  根据字符串生成时间
 *
 *  @param str    字符串
 *  @param format 时间格式
 *
 *  @return 时间
 */
- (NSDate *)getDateFromString:(NSString *)str Format:(NSString *)format;

/**
 *  根据时间生成字符串
 *
 *  @param date   时间
 *  @param format 时间格式
 *
 *  @return 时间字符串
 */
- (NSString *)getStringFromDate:(NSDate *)date Format:(NSString *)format;

/**
 *  根据时间戳.获取时间
 *
 *  @param time 时间戳字符串
 *
 *  @return 时间
 */
- (NSDate *)dbDate:(NSString *)time;

/**
 *  根据秒 获取分钟数
 *
 *  @param second 秒时长
 *
 *  @return 22:22
 */
- (NSString *)getDateFromSecond:(NSInteger)second;
/**
 *  根据秒 获取分钟数
 *
 *  @param second 秒时长
 *
 *  @return 22分22秒
 */
- (NSString *)getChineseDateFromSecond:(NSInteger)second;

/**
 *  获取当前格式化时间 2013:12:11 11:11:11
 *
 *  @return 当前时间
 */
- (NSString *)getNowDateFormatter;

/**
 *  获取当前时间  2013105221034
 *
 *  @return 当前时间

 */
- (NSString *)getNowDate;

/**
 *  根据时间获取秒数  例如:(01:30)==90s
 *
 *  @param strTime 时间串
 *
 *  @return 秒数
 */
+ (CGFloat)getDSceond:(NSString *)strTime;

/**
 *  获取当前时间 输出格式为：2010-10-27 10:22:13
 *
 *  @return 当前时间字符串
 */
+ (NSString *)getTimeStringWithFormmatter;

/**
 *  根据时间戳得到时间
 *
 *  @param str 时间戳
 *
 *  @return 时间字符串
 */
+ (NSString *)getCreateTime:(NSString*)str;

@end

#pragma mark - plist操作
@interface NSObject (PlistManager)
/*
 删除plist文件直接调用  [FileManager removeFile:path]
 */

/**
 *  把数据写入NSUserDefault
 *
 *  @param value value
 *  @param key   key
 */
+ (void)saveUserDefault:(id)value forKey:(NSString *)key;

/**
 *  根据key从NSUserDefault取值
 *
 *  @param key key
 *
 *  @return value
 */
+ (id)readUserDefault:(NSString *) key;

/**
 *  创建一个数组类型的plist文件  成功返回YES
 *
 *  @param array 被写入的数组
 *  @param path  路径
 *
 *  @return 返回写入成功还是失败
 */
+ (BOOL)createPlistForArray:(NSArray *)array forPath:(NSString *)path;

/**
*  创建一个字典类型的plist文件  成功返回YES
*
*  @param dictionary 创建一个字典类型的plist文件  成功返回YES
*  @param path       路径
*
*  @return 返回写入成功还是失败
*/

+ (BOOL)createPlistForDictionary:(NSDictionary *)dictionary forPath:(NSString *)path;
/**
 *  从plist文件获取数组  路径不对返回nil
 *
 *  @param path 路径
 *
 *  @return 读取的数组
 */
+ (NSArray*)getArrayFromPlist:(NSString *)path;

//从plist文件获取字典  路径不对返回nil
/**
 *  从plist读取字典  路径不对返回nil
 *
 *  @param path 路径
 *
 *  @return 读取的字典
 */
+ (NSDictionary*)getDictionaryFromPlist:(NSString *)path;

/**
 *  从plist文件里面拿到字典并且再次写入键值 (不可循环使用,影响效率)
 *
 *  @param path  路径
 *  @param key   key
 *  @param value value
 *  @return 設值之后的字典
 */
+ (NSMutableDictionary *)readDictionaryForPlist:(NSString *)path forKey:(NSString *)key forValue:(NSString *)value;

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
