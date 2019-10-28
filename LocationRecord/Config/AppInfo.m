//
//  UserInfo.m
//  Xt
//
//  Created by Johnson on 26/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "AppInfo.h"
#import "Header.h"
#import "ConstKeys.h"

const NSString * kCellIdentifier = @"kCellIdentifier";

@interface AppInfo()
@property (nonatomic, strong) BmobUser *user;
@end

@implementation AppInfo

static AppInfo *instance = nil;

+ (void)load
{
    [self shareInstance];
    [self getUser:nil];
}

+ (instancetype)shareInstance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppInfo alloc] init];
    });
    return instance;
}

+ (void)getUser:(void(^)(BmobUser *user))complete
{
    IF_RETURN(!instance.user, complete ? complete(instance.user) : nil; );
    
    [AppInfo loginWithUserName:@"ytx0573" password:@"1234567" complete:^(BOOL isSuccessful, NSArray *array, NSError *error) {
        complete ? complete(instance.user) : nil;
    }];
}

+ (void)registerUser:(NSString *)userName password:(NSString *)password complete:(void(^)(BOOL isSuccessful, NSError *error))complete;
{
    BmobObject *insert = [BmobObject objectWithClassName:kBmobTableName_User];
    [insert setObject:userName forKey:kBmobKey_user_username];
    [insert setObject:password forKey:kBmobKey_user_password];
    [insert saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        complete ? complete(isSuccessful, error) : nil;
    }];
}

+ (void)loginWithUserName:(NSString *)username password:(NSString *)password complete:(void(^)(BOOL isSuccessful, NSArray *array, NSError *error))complete;
{
    BmobQuery *bquery = [BmobQuery queryForUser];
    
    [bquery whereKey:kBmobKey_user_username equalTo:username];
    [bquery whereKey:kBmobKey_user_password equalTo:password];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        instance.user = array.firstObject;
        BOOL isSuccessful = array.count > 0;
        complete ? complete(isSuccessful, array, array.count == 0 ? [NSError errorWithDomain:@"用户不存在" code:0 userInfo:nil] : error) : nil;
    }];
}

@end
