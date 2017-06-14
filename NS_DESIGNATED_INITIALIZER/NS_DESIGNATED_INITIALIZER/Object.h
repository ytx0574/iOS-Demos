//
//  Object.h
//  NS_DESIGNATED_INITIALIZER
//
//  Created by Johnson on 11/06/2017.
//  Copyright © 2017 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/NSObjCRuntime.h>

/*
 
 NS_DESIGNATED_INITIALIZER 是Xcode6之后新增的一个黑魔法，通过它可以让我们充分发挥编译器的特性（编译时检查，语法错误后并给出warning），进而帮我们找出初始化过程中可能存在的漏洞，增加代码的健壮性，写出更规范的代码。
 
 


#ifndef NS_DESIGNATED_INITIALIZER
#if __has_attribute(objc_designated_initializer)
#define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#else
#define NS_DESIGNATED_INITIALIZER
#endif
#endif
 
 

此处为NSObject类的init方法定义， 如果当前类没有NS_DESIGNATED_INITIALIZER，那么默认把init方法作为NS_DESIGNATED_INITIALIZER；
 
 - (instancetype)init
 #if NS_ENFORCE_NSOBJECT_DESIGNATED_INITIALIZER
 NS_DESIGNATED_INITIALIZER
 #endif
 ;
 
*/


//Objective-C的默认的init函数为init之后第一个字母必须以大写字母开头，而且函数的返回值必须是instancetype或者id类型，否则如initobject2的命名方式无法作为NS_DESIGNATED_INITIALIZER

//NS_DESIGNATED_INITIALIZER不能出现在函数实现的地方@implementation和Category中；

//子类指定初始化函数必须调用父类的指定初始化函数进行初始化；

//子类没有指定初始化函数时，重写父类指定初始化函数，调用父类的指定初始化函数进行初始化，重写非指定初始化函数时，调用父类或子类任意初始化函数都可以；


//子类非指定初始化函数初始化时，如果子类有指定初始化函数，则调用本类的指定初始化函数，反之则调用父类的初始化函数或者（其他初始化函数，最终的调用还是走的指定初始化函数）。而且一旦子类添加指定初始化函数之后，那么优先级将高于父类；

//一旦子类有指定初始化函数时，那么init函数就不再是指定初始化函数，需手动重写init函数，并且init初始化时调用本类的指定初始化函数进行初始化；


//http://www.jianshu.com/p/8fca8ff11b7b         自博客记录


@interface Object : NSObject

@end

@interface SubObject : Object


@end





