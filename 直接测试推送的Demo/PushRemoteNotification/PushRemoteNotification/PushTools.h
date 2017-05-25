//
//  PushTools.h
//  Noti
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PusherKit.h"

@interface PushTools : NSObject

+ (void)pushRemoteNotification:(NSDictionary *)info
                         badge:(NSString *)badge
                         sound:(NSString *)sound
                   environment:(NWEnvironment)environment
                        isVoIP:(BOOL)isVoIP
                   deviceToken:(NSString *)deviceToken;

@end
