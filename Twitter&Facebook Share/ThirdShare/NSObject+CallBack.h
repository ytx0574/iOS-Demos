//
//  NSObject+CallBack.h
//  TestP
//
//  Created by jsonlong on 16/4/20.
//  Copyright © 2016年 zsgf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (CallBack)

@property (nonatomic, copy) void(^callBack)();

@end
