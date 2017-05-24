//
//  PushTools.h
//  Noti
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushTools : NSObject

+ (void)pushRemoteNotification:(NSDictionary *)info
                         badge:(NSString *)badge
                         sound:(NSString *)sound
                        isVoIP:(BOOL)isVoIP
                   deviceToken:(NSString *)deviceToken;

@end
