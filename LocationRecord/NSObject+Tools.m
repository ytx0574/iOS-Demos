
//  NSObject+AFNetworking.m
//  mat
//
//  Created by Johnson on 14-6-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NSObject+Tools.h"
#pragma mark - 获取设备型号使用
#include "sys/types.h"
#include "sys/sysctl.h"
#pragma mark - 获取对象信息使用
#import <objc/message.h>

#pragma mark - 辅助方法
#define DES_ENCRYPT_KEY @"DES_ENCRYPT_KEY"
@implementation NSObject (Accessibility)

+ (id)getKeyFromDicatinary:(NSDictionary *)dicationary value:(id)value;
{
    NSUInteger index = [[dicationary allValues] indexOfObject:value];
    id key = index > [[dicationary allKeys] count] - 1 ?  nil : [dicationary allKeys][index];
    if (!key) {
        NSLog(@"该value:%@,对应的key不存在!!!",value);
    }
    return key;
}

+ (id)convertResponseObject:(id)responseObject keys:(NSDictionary *)keys;
{
    if (!responseObject) {
        NSLog(@"返回的responseObject为空");
        return nil;
    }
    if (!keys) {
        keys = CONVERT_RESPONSE_KEYS;
    }
    __block NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    [[keys allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        responseString = [responseString stringByReplacingOccurrencesOfString:obj withString:keys[obj]];
    }];
    return [responseString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSArray *)getDifferentObjectForArray:(NSArray *)array1 array2:(NSArray *)array2;
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([array1 count] > [array2 count]) {
        [array1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![array2 containsObject:obj]) {
                [array addObject:obj];
            }
        }];
    }else {
        [array2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![array1 containsObject:obj]) {
                [array addObject:obj];
            }
        }];
    }
    if ([array count] > 0) {return array;}
    return nil;
}

+ (instancetype)initWithDictionary:(NSDictionary *)info
{
    id instance = [[[self class] alloc] init];
    [info isKindOfClass:[NSDictionary class]] ? [instance setUpWithDictionary:info] : nil;
    return instance;
}

- (void)setUpWithDictionary:(NSDictionary *)info
{
    [[info allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[self propertyList:[self class]] containsObject:obj]) {
            NSString *string = [NSString stringWithFormat:@"%@", info[obj]];
            [self setValue:[string isEqualToString:@"<null>"] ? EMPTY_STRING : string forKey:obj];
        }
    }];
}
- (void)copyProperty:(id)info
{
    [[info propertyList:[info class]] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self setValue:[info valueForKey:obj] forKey:obj];
    }];
}


- (void)delayPerform:(NSTimeInterval)delay complete:(void (^)(void))complete;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        complete ? complete() : nil;
    });
}

- (NSData *)encrypt:(NSString *)string
{
    return [NSString DESEncrypt:[string dataUsingEncoding:NSUTF8StringEncoding] WithKey:DES_ENCRYPT_KEY];
}

- (NSString *)decrypt:(NSData *)data
{
    return data ? [[NSString alloc] initWithData:[NSString DESDecrypt:data WithKey:DES_ENCRYPT_KEY] encoding:NSUTF8StringEncoding] : nil;
}

- (NSDictionary *)modelConvertDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [[self propertyList:[self class]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [dictionary setObject:[self valueForKey:obj] ?: EMPTY_STRING forKey:obj];
    }];
    return dictionary;
}

- (UIAlertView *)showAlert:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
}

- (UIAlertView *)showAlertOk:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
}

- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;
{
    UIAlertView *alertView = [self showAlert:title message:message];
    [alertView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:delay];
}

- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay complete:(void(^)())complete;
{
    [self showAlert:title message:message delay:delay];
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            complete ? complete() : nil;
        });
    });
}

@end

#pragma mark - Runtime
static void getSuper(Class class, NSMutableString *result)
{
    [result appendFormat:@" -> %@", NSStringFromClass(class)];
    if ([class superclass]) { getSuper([class superclass], result); }
}

@implementation NSObject (Runtime)

- (NSArray *)runtimeProperties
{
    return [[self class] runtimeProperties];
}

+ (NSArray *)runtimeProperties
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        [result addObject:[self formattedPropery:properties[i]]];
    }
    free(properties);
    return result.count ? [result copy] : nil;
}

- (NSString *)runtimeParentClassHierarchy
{
    return [[self class] runtimeParentClassHierarchy];
}

+ (NSString *)runtimeParentClassHierarchy
{
    NSMutableString *result = [NSMutableString string];
    getSuper([self class], result);
    return result;
}

- (NSArray *)runtimeSubClasses
{
    return [[self class] runtimeSubClasses];
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

- (size_t)runtimeInstanceSize
{
    return [[self class] runtimeInstanceSize];
}

+ (size_t)runtimeInstanceSize
{
    return class_getInstanceSize(self);
}

- (NSArray *)runtimeClassMethods
{
    return [[self class] runtimeClassMethods];
}

+ (NSArray *)runtimeClassMethods
{
    return [self methodsForClass:object_getClass([self class]) typeFormat:@"+"];
}

- (NSArray *)runtimeInstanceMethods
{
    return [[self class] runtimeInstanceMethods];
}

+ (NSArray *)runtimeInstanceMethods
{
    return [self methodsForClass:[self class] typeFormat:@"-"];
}

- (NSArray *)runtimeProtocols
{
    return [[self class] runtimeProtocols];
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

- (NSArray *)instanceMethodList:(Class)class;
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList(class,&mothCout_f);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i=0;i<mothCout_f;i++)
    {
        Method temp_f = mothList_f[i];
        const char* name_s =sel_getName(method_getName(temp_f));
        //        int arguments = method_getNumberOfArguments(temp_f);
        //        const char* encoding =method_getTypeEncoding(temp_f);
        //        NSLog(@"方法名：%@,参数个数：%ld,编码方式：%@",[NSString stringWithUTF8String:name_s],arguments,[NSString stringWithUTF8String:encoding]);
        [array addObject:[NSString stringWithUTF8String:name_s]];
    }
    free(mothList_f);
    return array;
}

- (NSMutableArray *)ivarList:(Class)class;
{
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList(class, &numIvars);
    NSMutableArray *variables = [[NSMutableArray alloc] init];
    NSString *key = nil;
    //    NSString *type = nil;
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
        //        NSLog(@"variable name :%@", key);
        [variables addObject:key];
        //        type = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
        //        NSLog(@"variable type :%@", type);
    }
    free(vars);
    return variables;
}

- (NSMutableArray *)propertyList:(Class)class;
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [array addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return array;
}

- (NSMutableDictionary *)getAllIvarAndVelues:(Class)class;
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    [[self ivarList:class] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [props setObject:[self valueForKey:obj] ?: @"" forKey:obj];
    }];
    return props;
}

- (NSMutableDictionary *)getAllPropertiesAndVaules:(Class)class;
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    [[self propertyList:class] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [props setObject:[self valueForKey:obj] ?: @"" forKey:obj];
    }];
    return props;
}

- (NSString *)getPropertyNameForValue:(id)value;
{
    unsigned int numIvars =0;
    NSString *key = nil;
    
    //Describes the instance variables declared by a class.
    Ivar * ivars = class_copyIvarList([self class], &numIvars);
    
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        
        //不是class就跳过
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        
        //Reads the value of an instance variable in an object. object_getIvar这个方法中，当遇到非objective-c对象时，并直接crash
        if ((object_getIvar(self, thisIvar) == value)) {
            // Returns the name of an instance variable.
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
}

- (NSString *)Log:(BOOL)showPropertyValue;
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSMutableArray *allMembersVariabelAndProperties =  [[NSMutableArray alloc] initWithArray:[self ivarList:[self class]]];
    [allMembersVariabelAndProperties addObjectsFromArray:[self propertyList:[self class]]];
    
    [allMembersVariabelAndProperties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        Class propertyAttributeClass = [[self valueForKey:(NSString *)obj] class];
        NSString *propertyValue = [self valueForKey:(NSString *)obj];
        
        [array addObject:[NSString stringWithFormat:@"属性名称:%@   对象类型:%@   指向地址:%p   %@",obj, propertyAttributeClass, propertyValue, showPropertyValue ? [NSString stringWithFormat:@"属性的值:%@",propertyValue] : EMPTY_STRING]];
        //        根据内存地址得到其指向的对象
        //        NSLog(@"%@",(id)memoryAddress);
    }];
    return [NSString stringWithFormat:@"Class Logs:\n->Next\n%@",[array componentsJoinedByString:@"\n->Next\n"]];
}

#pragma mark - RuntimePrivate

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

+ (NSArray *)formattedMethodsForProtocol:(Protocol *)proto required:(BOOL)required instance:(BOOL)instance {
    unsigned int methodCount;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(proto, required, instance, &methodCount);
    NSMutableArray *methodsDescription = [NSMutableArray array];
    for (int i = 0; i < methodCount; i++) {
        [methodsDescription addObject:
         [NSString stringWithFormat:@"%@ (%@)%@",
          instance ? @"-" : @"+", @"void",
          NSStringFromSelector(methods[i].name)]];
    }
    
    free(methods);
    return  [methodsDescription copy];
}

+ (NSString *)formattedPropery:(objc_property_t)prop {
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(prop, &attrCount);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    for (int idx = 0; idx < attrCount; idx++) {
        NSString *name = [NSString stringWithCString:attrs[idx].name encoding:NSUTF8StringEncoding];
        NSString *value = [NSString stringWithCString:attrs[idx].value encoding:NSUTF8StringEncoding];
        [attributes setObject:value forKey:name];
    }
    free(attrs);
    NSMutableString *property = [NSMutableString stringWithFormat:@"@property "];
    NSMutableArray *attrsArray = [NSMutableArray array];
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5
    [attrsArray addObject:[attributes objectForKey:@"N"] ? @"nonatomic" : @"atomic"];
    
    if ([attributes objectForKey:@"&"]) {
        [attrsArray addObject:@"strong"];
    } else if ([attributes objectForKey:@"C"]) {
        [attrsArray addObject:@"copy"];
    } else if ([attributes objectForKey:@"W"]) {
        [attrsArray addObject:@"weak"];
    } else {
        [attrsArray addObject:@"assign"];
    }
    if ([attributes objectForKey:@"R"]) {[attrsArray addObject:@"readonly"];}
    if ([attributes objectForKey:@"G"]) {
        [attrsArray addObject:[NSString stringWithFormat:@"getter=%@", [attributes objectForKey:@"G"]]];
    }
    if ([attributes objectForKey:@"S"]) {
        [attrsArray addObject:[NSString stringWithFormat:@"setter=%@", [attributes objectForKey:@"G"]]];
    }
    
    [property appendFormat:@"(%@) %@ %@",
     [attrsArray componentsJoinedByString:@", "],
     [NSString decodeType:[[attributes objectForKey:@"T"] cStringUsingEncoding:NSUTF8StringEncoding]],
     [NSString stringWithCString:property_getName(prop) encoding:NSUTF8StringEncoding]];
    return [property copy];
}

@end

#pragma mark - 文件管理
@implementation NSObject (FileManager)
+ (BOOL)createDirectory:(NSString *)path;
{
    NSFileManager *file=[NSFileManager defaultManager];
    BOOL flag=NO;
    flag=[file createDirectoryAtPath:path withIntermediateDirectories:NO attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],NSFileAppendOnly, nil] error:nil];
    if (flag) {
        NSLog(@"创建目录 Success");
    }else{
        NSLog(@"创建目录 Faild");
    }
    return flag;
}

+ (BOOL)createFile:(NSString *)path Content:(NSData *)data;
{
    NSFileManager *file=[NSFileManager defaultManager];
    BOOL flag=NO;
    flag=[file createFileAtPath:path contents:data attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],NSFileAppendOnly,nil]];
    if (flag) {
        NSLog(@"创建文件 Success");
    }else{
        NSLog(@"创建文件 Faild");
    }
    return flag;
}

+ (BOOL)isFile:(NSString *)path;
{
    NSFileManager *file=[NSFileManager defaultManager];
    BOOL flag1;
    BOOL isExist =[file fileExistsAtPath:path isDirectory:&flag1];
    if( isExist){
        if (flag1) {
            NSLog(@"该路径是一个目录");
            return NO;
        }else{
            NSLog(@"该路径是一个文件");
            return YES;
        }
    }
    else{
        NSLog(@"该路径不存在");
        return NO ;
    }
}

+ (BOOL)isExistsAtPath:(NSString *)path;
{
    NSFileManager *file=[NSFileManager defaultManager];
    if ([file fileExistsAtPath:path]) {
        NSLog(@"该路径存在");
        return YES;
    }else{
        NSLog(@"该路径不存在");
        return NO;
    }
}

+ (BOOL)removeFile:(NSString *)path;
{
    NSFileManager *file=[NSFileManager defaultManager];
    BOOL flag1;
    BOOL flg = NO;
    if ([file fileExistsAtPath:path isDirectory:&flag1]&&flag1) {
        NSLog(@"删除文件失败,删除的不是一个文件");
    }else{
        flg = [file removeItemAtPath:path error:nil];
    }
    if (flg) {
        NSLog(@"删除文件成功");
    }else{
        NSLog(@"删除文件失败");
    }
    return flg;
}

+ (BOOL)removeDirectory:(NSString *)path
{
    NSFileManager *file=[NSFileManager defaultManager];
    BOOL flag1;
    BOOL flg = NO;
    if ([file fileExistsAtPath:path isDirectory:&flag1]&&flag1) {
        flg = [file removeItemAtPath:path error:nil];
    }else{
        NSLog(@"删除目录失败,删除的不是一个目录");
    }
    if (flg) {
        NSLog(@"删除目录成功");
    }else{
        NSLog(@"删除目录失败");
    }
    return flg;
}

+ (NSString *)createDirectoryOnDocuments:(NSString *)dirName
{
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end

#pragma mark - 对时间的操作
@implementation NSObject (Time)

+ (NSDateFormatter *)getDateFormatter;
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}

- (NSString *)getNowDateForall:(NSInteger)type
{
    NSDate * now = [[NSDate alloc] init];
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:now];
    NSUInteger seconds=[cps second];
    NSUInteger hour = [cps hour];
    NSUInteger minute = [cps minute];
    NSUInteger day = [cps day];
    NSUInteger month = [cps month];
    NSUInteger year =[cps year];
    if(type == 0){
        return  [NSString stringWithFormat:@"%ld%ld%ld%2ld%02ld%02ld", year, month, day, hour, minute, seconds];
    }
    if (type == 1)
    {
        return [NSString stringWithFormat:@"%ld-%ld-%ld %02ld:%02ld:%02ld", year, month, day, hour, minute, seconds];
    }
    if (type == 2)
    {
        return [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
    }
    if (type == 3)
    {
        return [NSString stringWithFormat:@"%ld年%ld月%ld日 %2ld时:%2ld分:%2ld秒", year, month, day, hour, minute, seconds];
    }
    if (type == 4)
    {
        return [NSString stringWithFormat:@"%ld年%ld月%ld日 ", year, month, day];
    }
    return nil;
}

- (NSString *)intervalFromLastDate: (NSDate *) date;
{
    //两个时间的时间差
    NSInteger TimeDifference = fabs([date timeIntervalSinceDate:[NSDate date]]);
    if (TimeDifference / (60 * 60 * 24 * 30) > 0) {
        return [NSString stringWithFormat:@"%ld个月前", TimeDifference / (60 * 60 * 24 * 30)];
    }
    if (TimeDifference / (60 * 60 * 24 * 7) > 0) {
        return [NSString stringWithFormat:@"%ld周前", TimeDifference / (60 * 60 * 24 * 7)];
    }
    if (TimeDifference / (60 * 60 * 24) > 0) {
        return [NSString stringWithFormat:@"%ld天前", TimeDifference / (60 * 60 * 24)];
    }
    if (TimeDifference / (60 * 60) > 0) {
        return [NSString stringWithFormat:@"%ld小时前", TimeDifference / ( 60 * 60)];
    }
    if (TimeDifference / 60 > 0) {
        return [NSString stringWithFormat:@"%ld分钟前", TimeDifference / 60];
    }
    if (TimeDifference % 60 > 20) {
        return [NSString stringWithFormat:@"%ld秒前", TimeDifference % 60];
    }else {
        return @"刚刚";
    }
    return nil;
}

- (NSString *)getNowDateFileName:(NSString *)suffix
{
    NSDate * now = [[NSDate alloc] init];
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:now];
    NSUInteger hour = [cps hour];
    NSUInteger minute = [cps minute];
    NSUInteger day = [cps day];
    NSUInteger month = [cps month];
    NSUInteger year =[cps year];
    return [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld.%@", year, month, day, hour, minute, (NSInteger)arc4random() % 8888888, suffix];
}

- (NSDate *)getDateFromString:(NSString *)str Format:(NSString *)format
{
    [[NSObject getDateFormatter] setDateFormat:format];
    if (str.length != format.length) {
        NSLog(@"请仔细检查输入字符串格式是否正确");
        return nil;
    }
    NSDate *tempdate=[NSDate dateWithTimeInterval:8 * 60 * 60 sinceDate:[[NSObject getDateFormatter] dateFromString:str]];
    if ([[tempdate.description substringFromIndex:tempdate.description.length-17] isEqualToString:@"596:-31:-23 +0000"]) {
        NSLog(@"请仔细检查输入字符串格式是否正确");
        return nil;
    }
//    NSLog(@"%@",[[NSObject getDateFormatter] dateFromString:str])
//    return [NSDate dateWithTimeInterval:8 * 60 * 60 sinceDate:[[NSObject getDateFormatter] dateFromString:str]];
    return [[NSObject getDateFormatter] dateFromString:str];
}

- (NSString *)getStringFromDate:(NSDate *)date Format:(NSString *)format
{
    [[NSObject getDateFormatter] setDateFormat:format];
    return [[NSObject getDateFormatter] stringFromDate:date];
}

- (NSDate *)dbDate:(NSString *)time
{
    NSString *regex = @"^[0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    NSDate *date = nil;
    if ([test evaluateWithObject:time]){
        date=[NSDate dateWithTimeIntervalSinceNow:[time longLongValue] + 8 * 60 * 60];
    }else{
        NSLog(@"输入的时间戳格式不对");
    }
    return date;
}

- (NSString *)getDateFromSecond:(NSInteger)second
{
    if (second > 600 && second % 60 >= 10) {
        return [NSString stringWithFormat:@"%@:%@", @(second / 60), @(second % 60)];
    }else if (second > 600 && second % 60 < 10){
        return [NSString stringWithFormat:@"%@:0%@", @(second / 60), @(second % 60)];
    }else if (second < 600 && second % 60 >= 10){
        return [NSString stringWithFormat:@"0%@:%@", @(second / 60), @(second % 60)];
    }else if (second < 600 && second % 60 < 10){
        return [NSString stringWithFormat:@"0%@:0%@", @(second / 60), @(second % 60)];
    }else if (second < 60 && second % 60 >= 10){
        return [NSString stringWithFormat:@"00:%@", @(second % 60)];
    }else{
        return [NSString stringWithFormat:@"00:0%@", @(second % 60)];
    }
}

- (NSString *)getChineseDateFromSecond:(NSInteger)second
{
    NSString *stringDate = [self getDateFromSecond:second];
    if ([stringDate hasPrefix:@"00"]) {
        stringDate = [stringDate stringByReplacingOccurrencesOfString:@"00:" withString:@""];
    }
    
    stringDate = [stringDate stringByReplacingOccurrencesOfString:@":" withString:@"分"];
    stringDate = [stringDate stringByAppendingString:@"秒"];
    
    if ([stringDate hasPrefix:@"0"]) {
        stringDate = [stringDate substringFromIndex:1];
    }
    
    return stringDate;
}

- (NSString *)getNowDateFormatter
{
    NSDate * now = [[NSDate alloc] init];
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:now];
    NSUInteger seconds=[cps second];
    NSUInteger hour = [cps hour];
    NSUInteger minute = [cps minute];
    NSUInteger day = [cps day];
    NSUInteger month = [cps month];
    NSUInteger year =[cps year];
    return [NSString stringWithFormat:@"%ld-%ld-%ld %02ld:%02ld:%02ld", year, month, day, hour, minute, seconds];
}

-(NSString *)getNowDate
{
    NSDate * now = [[NSDate alloc] init];
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:now];
    NSUInteger hour = [cps hour];
    NSUInteger minute = [cps minute];
    NSUInteger seconds=[cps second];
    NSUInteger day = [cps day];
    NSUInteger month = [cps month];
    NSUInteger year =[cps year];
    return [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld", year, month, day, hour, minute, seconds];
}

+ (CGFloat)getDSceond:(NSString *)strTime;
{
    NSArray *ay=[strTime componentsSeparatedByString:@":"];
    return  [ay.firstObject integerValue] * 60 + [ay.lastObject integerValue];
}

+ (NSString *)getTimeStringWithFormmatter
{
    [[NSObject getDateFormatter] setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [[NSObject getDateFormatter] stringFromDate:[NSDate date]];
    return  currentDateStr;
}

+ (NSString *)getCreateTime:(NSString*)str
{
    [[NSObject getDateFormatter] setDateFormat:@"yyyy-MM-dd "];
    NSString *currentDateStr = [[NSObject getDateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:str.longLongValue]];
    return  currentDateStr;
}

@end

#pragma mark - plist操作
@implementation NSObject (PlistManager)

+ (void)saveUserDefault:(id)value forKey:(NSString *)key;
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setValue:value forKey:key];
    [userDefault synchronize];
}

+ (id)readUserDefault:(NSString *) key;
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    return [userDefault valueForKey:key];
}

+ (BOOL)createPlistForArray:(NSArray *)array forPath:(NSString *)path;
{
    BOOL flag = NO;
    if (array) {
        if ([[path substringFromIndex:path.length - 6] isEqualToString:@".plist"]) {
            flag = [array writeToFile:path atomically:YES];
            if (flag) {
                NSLog(@"生成数组类型的plist  Success");
            }else{
                NSLog(@"生成数组类型的plist  Faild");
            }
        }
        else{
            NSLog(@"指定路径不是一个plist文件");
        }
    }
    else{
        NSLog(@"传入的数组不能为 nil");
    }
    return flag;
}

+ (BOOL)createPlistForDictionary:(NSDictionary *)dictionary forPath:(NSString *)path;
{
    BOOL flag = NO;
    if (dictionary) {
        if ([[path substringFromIndex:path.length - 6] isEqualToString:@".plist"]) {
            flag = [dictionary writeToFile:path atomically:YES];
            if (flag) {
                NSLog(@"生成字典类型的plist  Success");
            }else{
                NSLog(@"生成字典类型的plist  Faild");
            }
        }
        else{
            NSLog(@"指定路径不是一个plist文件");
        }
    }
    else{
        NSLog(@"传入的字典不能为 nil");
    }
    return flag;
}

//从plist文件获取数组
+ (NSArray*)getArrayFromPlist:(NSString *)path;
{
    if ([NSObject isFile:path]) {
        return [NSArray arrayWithContentsOfFile:path];
    }else{
        return nil;
    }
}

//从plist文件获取字典
+ (NSDictionary*)getDictionaryFromPlist:(NSString *)path;
{
    if ([NSObject isFile:path]) {
        return [NSDictionary dictionaryWithContentsOfFile:path];
    }else{
        return nil;
    }
}

+ (NSMutableDictionary *)readDictionaryForPlist:(NSString *)path forKey:(NSString *)key forValue:(NSString *)value;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:path];
    NSMutableDictionary *dict = nil;
    if( [NSObject isFile:plistPath]){
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }else{
        dict = [[NSMutableDictionary alloc]init];
    }
    [dict setObject:value forKey:key];
    
    [dict writeToFile:plistPath atomically:YES];
    return dict;
}

@end

#pragma mark - 设备信息
@implementation NSObject (UIDeviceType)

+ (NSString *)getDeviceType{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air2 (A1566)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air2 (A1567)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini3 (A1601)";
    
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (A1584)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (A1652)";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini4 (A1550)";
    
    
    if ([platform isEqualToString:@"Watch1,1"])   return @"Apple Watch (A1553)";
    if ([platform isEqualToString:@"Watch1,2"])   return @"Apple Watch (A1554/A1638)";
    
    
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G (A1378)";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3G (A1427)";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3G (A1469)";
    if ([platform isEqualToString:@"AppleTV5,3"])   return @"Apple TV 4G (A1625)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString *)getSystemVersion;
{
    return [[UIDevice currentDevice] systemVersion];
}

@end

#pragma mark - 获取对象的信息
@implementation NSObject (Thread)

- (void)performInBackground:(void(^)(void))backgroundCode
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        backgroundCode ? backgroundCode() : nil;
    });
}

- (void)performOnMainThread:(void(^)(void))mainCode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        mainCode ? mainCode() : nil;
    });
}

- (void)performInBackground:(void(^)(void))backgroundCode onMainThread:(void(^)(void))mainCode
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        backgroundCode ? backgroundCode() : nil;
//        dispatch_async(dispatch_get_main_queue(), ^{
            mainCode ? mainCode() : nil;
//        });
    });
}
@end
