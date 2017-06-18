//
//  SelectMedia.h
//  ThirdShare
//
//  Created by Johnson on 10/06/2017.
//  Copyright © 2017 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SelectMedia : NSObject


+ (void)selectVideoWithViewControler:(UIViewController *)vc complete:(void(^)(NSDictionary<NSString *,id> *info))complete;


+ (void)selectPhotoWithViewControler:(UIViewController *)vc complete:(void(^)(NSDictionary<NSString *,id> *info))complete;


+ (void)selectPhotosWithViewControler:(UIViewController *)vc max:(NSUInteger)max complete:(void(^)(NSArray <UIImage *> *images))complete;

@end
