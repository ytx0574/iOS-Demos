//
//  BaseModel.h
//  Xt
//
//  Created by Johnson on 30/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const kBmobTableName_User;
extern NSString * const kBmobTableName_UserLocation;


//通用
extern NSString * const kBmobKey_objectId;
extern NSString * const kBmobKey_createAt;
extern NSString * const kBmobKey_updateAt;

//用户表
extern NSString * const kBmobKey_user_username;
extern NSString * const kBmobKey_user_password;
extern NSString * const kBmobKey_user_mobilePhoneNumberVer;
extern NSString * const kBmobKey_user_mobilePhoneNumber;
extern NSString * const kBmobKey_user_email;
extern NSString * const kBmobKey_user_emailVerified;
extern NSString * const kBmobKey_user_authData;

//地址表
extern NSString * const kBmobKey_userLocation_addressName;
extern NSString * const kBmobKey_userLocation_addressLocation;
extern NSString * const kBmobKey_userLocation_addressDetail;
extern NSString * const kBmobKey_userLocation_userObjectId;
