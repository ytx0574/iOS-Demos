//
//  AMapSubPOI+Bind.m
//  GaodeMap
//
//  Created by Johnson on 2019/8/27.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "AMapSubPOI+Bind.h"
#import <Aspects/Aspects.h>

@implementation AMapSubPOI (Bind)

+ (void)load
{
    [AMapPOI aspect_hookSelector:@selector(setSubPOIs:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        AMapPOI *poi = [info instance];
        
        [poi.subPOIs enumerateObjectsUsingBlock:^(AMapSubPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.superPOI = poi;
        }];
    } error:nil];
    
    [AMapSubPOI aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        AMapSubPOI *subPOI = [info instance];
        subPOI.superPOI = nil;
    } error:nil];
}

- (AMapPOI *)superPOI
{
    return objc_getAssociatedObject(self, @selector(superPOI));
}

- (void)setSuperPOI:(AMapPOI *)superPOI
{
    objc_setAssociatedObject(self, @selector(superPOI), superPOI, OBJC_ASSOCIATION_ASSIGN);
}

@end
