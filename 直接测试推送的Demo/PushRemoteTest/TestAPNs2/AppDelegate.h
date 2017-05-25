//
//  AppDelegate.h
//  TestAPNs2
//
//  Created by Johnson on 2017/5/9.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, copy) NSString *stringAPSsToken;

@property (nonatomic, copy) NSString *stringPushKitToken;

@property (strong, nonatomic) NSMutableDictionary *dictionaryRemoteInfo;

- (void)copyTokenToPasteboard;

@end

