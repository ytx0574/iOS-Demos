//
//  BaseModel.m
//  Xt
//
//  Created by Johnson on 30/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "ConstKeys.h"

NSString * const kBmobTableName_User = @"_User";
NSString * const kBmobTableName_UserLocation = @"UserLocation";


//通用
NSString * const kBmobKey_objectId = @"objectId";
NSString * const kBmobKey_createAt = @"createAt";
NSString * const kBmobKey_updateAt = @"updateAt";

//用户表
NSString * const kBmobKey_user_username = @"username";
NSString * const kBmobKey_user_password = @"password";
NSString * const kBmobKey_user_mobilePhoneNumberVer = @"mobilePhoneNumberVer";
NSString * const kBmobKey_user_mobilePhoneNumber = @"mobilePhoneNumber";
NSString * const kBmobKey_user_email = @"email";
NSString * const kBmobKey_user_emailVerified = @"emailVerified";
NSString * const kBmobKey_user_authData = @"authData";

//地址表
NSString * const kBmobKey_userLocation_addressName = @"addressName";
NSString * const kBmobKey_userLocation_addressLocation = @"addressLocation";
NSString * const kBmobKey_userLocation_addressDetail = @"addressDetail";
NSString * const kBmobKey_userLocation_userObjectId = @"userObjectId";

