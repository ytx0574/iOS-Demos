//
//  OpenMap.h
//  Xt
//
//  Created by Johnson on 30/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, MapType)
{
    MapTypeApple,
    MapTypeGoogle,
    MapTypeBaidu,
    MapTypeGaode,
    MapTypeNone,
};

@interface OpenMap : NSObject

+ (void)openMapWithType:(MapType)mapType coordinate:(CLLocationCoordinate2D)coordinate complete:(void(^)(NSError *error))complete;

@end
