//
//  MACustomPointAnnotation.h
//  GaodeMap
//
//  Created by Johnson on 2019/8/26.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MACustomPointAnnotation : MAPointAnnotation
@property (nonatomic, strong) AMapPOI *poi;
@property (nonatomic, strong) AMapSubPOI *subPOI;
@end

NS_ASSUME_NONNULL_END
