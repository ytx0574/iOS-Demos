//
//  UserInfo.h
//  Xt
//
//  Created by Johnson on 26/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface AppInfo : NSObject

@property (nonatomic, strong, readonly) BmobUser *user;

+ (void)getUser:(void(^)(BmobUser *user))complete;

+ (void)registerUser:(NSString *)userName password:(NSString *)password complete:(void(^)(BOOL isSuccessful, NSError *error))complete;

+ (void)loginWithUserName:(NSString *)username password:(NSString *)password complete:(void(^)(BOOL isSuccessful, NSArray *array, NSError *error))complete;


@end
