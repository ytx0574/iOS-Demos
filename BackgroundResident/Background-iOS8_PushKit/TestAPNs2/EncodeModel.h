//
//  EncodeModel.h
//  Noti
//
//  Created by Johnson on 2017/5/12.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodeModel : NSObject

@property (nonatomic, copy) NSDictionary *info;

@property (nonatomic, assign) float send_recv_timeinterval;

@property (nonatomic, assign) float last_recv_timeinterval;

@end
