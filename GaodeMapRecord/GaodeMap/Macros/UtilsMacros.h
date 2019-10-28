//
//  UtilsMacros.h
//  HealthFemale
//
//  Created by tg on 17/4/20.
//  Copyright © 2017年 tg. All rights reserved.
//

/*********************************** Log *********************************************/
//#define NSLog(format, ...) fprintf(stderr, "-----override NSLog-----<%s : %d> %s\n", \
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
//__LINE__, __func__); \
//(NSLog)((format), ##__VA_ARGS__);


#ifdef DEBUG

#define NSLog(FORMAT, ...) (void)fprintf(stderr,"\nfunction:%s line:%d content:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

#else

#define NSLog(FORMAT, ...) nil

#endif

/*******************************判断当前系统版本*************************************/
#pragma mark - 判断当前系统版本

/**传入参数判断系统是哪个版本*/
#define iOS_SYSTEM_VERSION(version)                 [[[UIDevice currentDevice] systemVersion] hasPrefix:@(version).stringValue]
/**传入参数,判断系统版本是多少,及以后*/
#define iOS_SYSTEM_LATER(version)                   (([[[UIDevice currentDevice] systemVersion] floatValue] >= version) ? YES : NO)
/**版本不一致的代码*/
#define MATCHING_SYSTEM_VERSION_CODE_LATER_ADN_EARLIER(isVersionLater, later, earlier)   if (isVersionLater){later;}else{earlier;}
/** iOS 8 7 6  的判定*/
#define iOS11                                       (iOS_SYSTEM_VERSION(11))
#define iOS10                                       (iOS_SYSTEM_VERSION(10))
#define iOS9                                        (iOS_SYSTEM_VERSION(9))
#define iOS8                                        (iOS_SYSTEM_VERSION(8))
#define iOS7                                        (iOS_SYSTEM_VERSION(7))
#define iOS6                                        (iOS_SYSTEM_VERSION(6))
#define iOS7_AND_LATER                              (iOS_SYSTEM_LATER(7) ? YES : NO)
#define iOS8_AND_LATER                              (iOS_SYSTEM_LATER(8) ? YES : NO)
#define iOS9_AND_LATER                              (iOS_SYSTEM_LATER(9) ? YES : NO)
#define iOS10_AND_LATER                             (iOS_SYSTEM_LATER(10) ? YES : NO)
#define iOS11_AND_LATER                             (iOS_SYSTEM_LATER(11) ? YES : NO)
/** 当前版本 */
#define kCurrenVersion                              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/********************************字体*******************************************/
#pragma mark - 字体

#define Font(font)                                  [UIFont fontWithName:@"Helvetica" size:(font)]
#define BoldFont(font)                              [UIFont fontWithName:@"Helvetica-Bold"  size:(font)]

/********************************系统高度*******************************************/
#pragma mark - 系统高度

#define SCREEN_WIDTH                                ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                               ([UIScreen mainScreen].bounds.size.height)

/** 状态栏高度 */
#define STATUSBAR_HEIGHT                            [[UIApplication sharedApplication] statusBarFrame].size.height
/** 导航栏高度 */
#define NAVIGATIONBAR_HEIGHT                        44.0
/** 判断屏幕大小 */
#define IS_SIZE_OF_3_5                              (SCREEN_HEIGHT == 480 ? YES : NO)
#define IS_SIZE_OF_4_0                              (SCREEN_HEIGHT == 568 ? YES : NO)
#define IS_SIZE_OF_4_7                              (SCREEN_HEIGHT == 667 ? YES : NO)
#define IS_SIZE_OF_5_5                              (SCREEN_HEIGHT == 736 ? YES : NO)
#define IS_SIZE_OF_5_8                              (SCREEN_HEIGHT == 812 ? YES : NO)
#define IS_SIZE_OF_320                              (SCREEN_WIDTH == 320)
#define IS_SIZE_OF_375                              (SCREEN_WIDTH == 375)
#define IS_SIZE_OF_414                              (SCREEN_WIDTH == 414)
#define IS_CORNER_SCREEN                            (STATUSBAR_HEIGHT > 20.f)  //判断类似iPhone X的刘海屏幕,X之后的机型

/** 已知各种高度 */
#define TABBAR_HEIGHT                               (IS_CORNER_SCREEN ? 83 : 49)
#define STATUSBAR_NAVIGATIONBAR_HEIGHT              (STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT)
#define SAFE_AREA_TOP_HEIGHT                        (IS_CORNER_SCREEN ? STATUSBAR_HEIGHT : 0)
#define SAFE_AREA_BOTTOM_HEIGHT                     (IS_CORNER_SCREEN ? 34 : 0)

/********************************System class or path*******************************************/
#pragma mark - System class or path

/** KEYWINDOW对象 */
#define KEY_WINDOW                                   [[UIApplication sharedApplication] keyWindow]
/** AppDelegate对象 */
#define APPDELEGATE_INSTANCE                         ((AppDelegate *)[[UIApplication sharedApplication] delegate])
/** RootViewController对象 */
#define kRootViewController                          [[[[UIApplication sharedApplication] delegate] window] rootViewController]
/** RootViewController对象 */
#define kRootTVC                                     ([kApplicationRootViewController  isKindOfClass:[TabBarVC class]] ? ((TabBarVC *)kApplicationRootViewController) : nil)

/********************************系统目录*******************************************/
#pragma mark - 系统目录

/** App主目录   可见子目录(3个):Documents、Library、tmp */
#define APP_PATH                                     NSHomeDirectory()
/** Documents路径   文档目录(ITUNES要同步) */
#define APP_DOCUMENTS_PATH                           [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
/** Library路径   资源目录 */
#define APP_LIBRARY_PATH                             [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
/** Library/Caches   资源缓存(ITUNES不同步) */
#define APP_LIBRARY_CACHES_PATH                      [APP_LIBRARY_PATH stringByAppendingPathComponent:@"/Caches"]
/** Library/Preferences  配置目录(ITUNES要同步) */
#define APP_LIBRARY_PREFERENCES_PATH                 [APP_LIBRARY_PATH stringByAppendingPathComponent:@"/Preferences"]
/** tmp目录   缓存目录(ITUNES不同步,程序退出后自动清空) */
#define APP_TMP_PATH                                 [NSHomeDirectory() stringByAppendingFormat:@"/tmp"]

/********************************加载NIB*******************************************/
#pragma mark - 加载NIB

/** 获取MAINBUNDLE */
#define MAIN_BUNDLE                                  [NSBundle mainBundle]

#define NIB_FROM_CLASS(class)                        [UINib nibWithNibName:NSStringFromClass(class) bundle:[NSBundle mainBundle]]
/** 加载nib文件 */
#define LOAD_NIB(_NibName_)                          [MAIN_BUNDLE loadNibNamed:_NibName_ owner:nil options:nil][0]
/** 加载从nib加载view*/
#define LOAD_VIEW_FROM_NIB(CLASS)                    [MAIN_BUNDLE loadNibNamed:NSStringFromClass([CLASS class]) owner:nil options:nil].firstObject
#define LOAD_VIEWS_FROM_NIB(CLASS)                   [MAIN_BUNDLE loadNibNamed:NSStringFromClass([CLASS class]) owner:nil options:nil]
/** 加载图片  内存 */
#define LOAD_IMAGE(filename)                         [UIImage imageNamed:filename]
/** 加载图片(bundle中获取  PNG)  从文件加载 */
#define LOAD_IMAGE_WITH_FILE_FROM_BUNDLE(filename)    [UIImage imageWithContentsOfFile:BANDLE_FILE_PATH(BANDLE_FILE_PATH(filename, @"png") ? filename : [filename stringByAppendingString:@"@2x"],@"png")]
/** 获取bundle文件路径 */
#define BANDLE_FILE_PATH(filename,extension)         [MAIN_BUNDLE pathForResource:filename ofType:extension]
/** 加载图片  从文件加载 */
#define LOAD_IMAGE_WITH_FILE_PATH(path)              [UIImage imageWithContentsOfFile:path]

/********************************TatbleView/CollectionView Register*******************************************/

#define TABLEVIEW_REGISTER_NIB(tableView, CLASS, identifier) \
[tableView registerNib:NIB_FROM_CLASS([CLASS class]) forCellReuseIdentifier:identifier]

#define TABLEVIEW_REGISTER_CLASS(tableView, CLASS, identifier) \
[_tableView registerClass:[CLASS class] forCellReuseIdentifier:identifier]

#define COLLECTIONVIEW_REGISTER_NIB(collectionView, CLASS, identifier) \
[collectionView registerNib:NIB_FROM_CLASS([CLASS class]) forCellWithReuseIdentifier:identifier]

#define COLLECTIONVIEW_REGISTER_CLASS(collectionView, CLASS, identifier) \
[collectionView registerClass:[CLASS class] forCellWithReuseIdentifier:identifier]

#define COLLECTIONVIEW_REGISTER_SECTION_NIB(collectionView, CLASS, ElementKindString, identifier) \
[collectionView registerNib:NIB_FROM_CLASS([CLASS class]) forSupplementaryViewOfKind:ElementKindString withReuseIdentifier:identifier]

#define COLLECTIONVIEW_REGISTER_SECTION_CLASS(collectionView, CLASS, ElementKindString, identifier) \
[collectionView registerClass:NIB_FROM_CLASS([CLASS class]) forSupplementaryViewOfKind:ElementKindString withReuseIdentifier:identifier]

#define MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle]

/********************************设置数组字典单例值*******************************************/
#pragma mark - 设置数组字典单例值

#define  GetVariableParameterWithMutableArray     \
NSMutableArray *array = [NSMutableArray array];\
if (firstValue) {\
va_list list;\
va_start(list, firstValue);\
[array addObject:firstValue];\
NSObject *value = va_arg(list, id);\
while (value) {\
value ? [array addObject:value] : nil;\
value = va_arg(list, id);\
}\
va_end(list);\
}\

#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \


/********************************各种判断*******************************************/
#pragma mark - 各种判断

/** 判断字符串是否是空字符串   (@"") */
#define EMPTY_STRING                                     @""
#define IS_EmptyString(_str_)                            [_str_ isEqualToString:EMPTY_STRING]
/** 判断一个对象是否为nil  不为nil返回YES */
#define IS_NOT_nil(class)                                (class != nil ? YES : NO)
/** 判断一个对象是否为null 不为null返回YES */
#define IS_NOT_null(class)                               ([class isEqual:[NSNull null]] ? NO : YES)
/** 判断一个对象是否存在  即不等于nil也不为null才返回YES */
#define IS_NOT_nilANDnull(class)                         ((class == nil || [class isEqual:[NSNull null]]) ? NO : YES)
/** 判断字符串(仅限字符串)      即不等于nil也不为null也不为@""才返回YES */
#define IS_NOT_nilORnullOREmptyString(class)             ((class == nil || [class isEqual:[NSNull null]] || [class isEqualToString:EMPTY_STRING] || [class isEqualToString:@"null"] || [class isEqualToString:@"(null)"] || [class isEqualToString:@"<null>"] || [class isEqualToString:@"<nil>"]) ? NO : YES)
/** if 判定 */
#define JUDGE_IF(condition, contentWithTrue)                           if (condition) { contentWithTrue; }
/** if else 判定 */
#define JUDGE_IF_ELSE(condition, contentWithTrue, contentWithFalse)    if (condition) { contentWithTrue; }else { contentWithFalse; }
/** if return 判定 */
#define IF_RETURN(condition, code)                                     if (condition) { code; return; }
/** if return value 判定 */
#define IF_RETURN_VALUE(condition, code, returnValue)                  if (condition) { code; return returnValue; }

//判断iPHoneXr
#define SCREENSIZE_IS_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPHoneX、iPHoneXs
#define SCREENSIZE_IS_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define SCREENSIZE_IS_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPhoneXs Max
#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

//等比适配
#define KScaleHH(c) [[UIScreen mainScreen] bounds].size.width / 320 * c
#define KScaleVV(c) KScaleHH(c)

/********************************view frame*******************************************/
#pragma mark - view frame

#define RECT(x, y, width, height)            (CGRect){x, y, width, height}
#define RECT_ORIGIN(origin, width, height)   (CGRect){origin, width, height}
#define RECT_SIZE(x, y, size)                (CGRect){x, y, size}
#define RECT_ORIGIN_SIZE(origin, size)       (CGRect){origin, size}

#define ORIGIN(view)                         view.frame.origin
#define SIZE(view)                           view.frame.size
#define FRAME(view)                          view.frame
#define ORIGIN_X(view)                       view.frame.origin.x
#define ORIGIN_Y(view)                       view.frame.origin.y
#define SIZE_W(view)                         view.frame.size.width
#define SIZE_H(view)                         view.frame.size.height

#define SizeScale                            ((SCREEN_WIDTH >= 667) ? 1.25 : 1.15)
/** 设置View的tag属性 */
#define VIEW_WITH_TAG(view, tag)             [view viewWithTag:tag]
/**失去第一响应者*/
#define RESIGN_FIRST_RESPONDER               [[UIApplication sharedApplication].keyWindow endEditing:YES]

/********************************OC*******************************************/
#pragma mark - OC

#define CONVERT_INTANCE_TYPE(_class, instance)            ((_class *)instance)
#define CONVERT_INTANCE_TYPE_IGNORE_VERIFY(_class, instance)  ([instance isKindOfClass:[_class class]] ? ((_class *)instance) : nil)

#define CONVERT_TO_STRING(instance)                       [NSString stringWithFormat:@"%@", instance]
#define SET_STRINGVALUE_WITH_STRING(str, valueStr)        if (![str isEqualToString:valueStr]) { str = valueStr; }
#define STRINGVALUE_UNEMPTY_STRING(value)                 ([value isEqual:EMPTY_STRING] ? nil : value)


NS_INLINE NSDate *GET_DATE_FROM_TIMESTAMP(NSInteger timeStamp) {
    return [NSDate dateWithTimeIntervalSince1970:timeStamp];
}

/********************************弹出AlterView*******************************************/
#pragma mark - 弹出AlterView

#define ALERT(msg)         [[[UIAlertView alloc]initWithTitle:@"系统提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

/********************************G－C－D*******************************************/
#pragma mark - GCD

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
#define AFTER(_delay_,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delay_ * NSEC_PER_SEC)), dispatch_get_main_queue(),block)

/********************************简洁写法*******************************************/
#pragma mark - 简洁写法

#define Image(imageName)       [UIImage imageNamed:(imageName)]

#pragma mark - J自定义字段控制

#define IGNORE_FUNCTION_FROM_FLAG(ignore_flag, code) \
if (ignore_flag) { \
    NSLog(@"此处原有功能被忽略"); \
}else { \
    code; \
}

#define IGNORE_FUNCTION_FROM_JDEVICE(ignore, code) \
BOOL jdevice = ignore && [NSHomeDirectory() hasPrefix:@"/Users/johnson/"]; \
IGNORE_FUNCTION_FROM_FLAG(jdevice, code)

#pragma mark - Code Macro

#define CATEGORY_PROPERTY_STRONG_TYPE(getter_method_name, setter_method_name, type)\
- (type *)getter_method_name\
{\
return objc_getAssociatedObject(self, _cmd);\
}\
\
- (void)set##setter_method_name:(type *)getter_method_name\
{\
objc_setAssociatedObject(self, @selector(getter_method_name), getter_method_name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\

#define CATEGORY_PROPERTY_COPY_TYPE(getter_method_name, setter_method_name, type)\
- (type *)getter_method_name\
{\
return objc_getAssociatedObject(self, _cmd);\
}\
\
- (void)set##setter_method_name:(type *)getter_method_name\
{\
objc_setAssociatedObject(self, @selector(getter_method_name), getter_method_name, OBJC_ASSOCIATION_COPY_NONATOMIC);\
}\

#define CATEGORY_PROPERTY_ASSIGN_TYPE(getter_method_name, setter_method_name, type, getValueMethod)\
- (type)getter_method_name\
{\
return [objc_getAssociatedObject(self, _cmd) getValueMethod];\
}\
\
- (void)set##setter_method_name:(type)getter_method_name\
{\
objc_setAssociatedObject(self, @selector(getter_method_name), @(getter_method_name), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\

