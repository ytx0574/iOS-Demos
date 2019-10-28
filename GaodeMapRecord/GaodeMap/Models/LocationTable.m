//
//  LocationTable.m
//  GaodeMap
//
//  Created by Johnson on 2019/8/27.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "LocationTable.h"
#import "NSObject+Runtime.h"
#import <MJExtension/MJExtension.h>

@implementation LocationTable

- (void)dealloc
{
    [self enumeratePropertiesWithBlock:^(NSUInteger idx, NSString *property, BOOL *stop) {
        [self removeObserver:self forKeyPath:property];
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self enumeratePropertiesWithBlock:^(NSUInteger idx, NSString *property, BOOL *stop) {
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
        }];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    id newValue = change[@"new"];
    newValue = [newValue isEqual:NSNull.null] ? nil : newValue;
    newValue ? [self setObject:newValue forKey:keyPath] : nil;
}



- (void)copyInfoFromPOIInfo:(AMapPOI *)poi;
{
    [self enumeratePropertiesWithBlock:^(NSUInteger idx, NSString *property, BOOL *stop) {
        @try {
            [self setObject:[poi valueForKey:property] forKey:property];
        } @catch (NSException *exception) {
            
        } @finally {
        
        }
    }];
    
    self.images = [poi.images.rac_sequence map:^id _Nullable(AMapImage * _Nullable value) {
        return [value mj_JSONObject];
    }].array.mj_JSONString;
    
    self.latitude = poi.location.latitude;
    self.longitude = poi.location.longitude;
    
    self.floor = poi.indoorData.floor;
    self.floorName = poi.indoorData.floorName;
    self.pid = poi.indoorData.pid;
    
    self.rating = poi.extensionInfo.rating;
    self.cost = poi.extensionInfo.cost;
    self.openTime = poi.extensionInfo.openTime;
}

- (void)cppyInfoFromSubPOIInfo:(AMapSubPOI *)subPOI;
{
    [self copyInfoFromPOIInfo:subPOI.superPOI];
    
    self.sname = subPOI.sname;
    self.subtype = subPOI.subtype;
    
    self.uid = subPOI.uid;
    self.name = subPOI.uid;
    self.latitude = subPOI.location.latitude;
    self.longitude = subPOI.location.longitude;
    self.address = subPOI.address;
    self.distance = subPOI.distance;
}

+ (instancetype)instaceWithAVObject:(AVObject *)avObject;
{
    if (![avObject.className isEqualToString:NSStringFromClass(LocationTable.class)]) {
        return nil;
    }
    LocationTable *value = [LocationTable objectWithClassName:NSStringFromClass(LocationTable.class)];
    [value enumeratePropertiesWithBlock:^(NSUInteger idx, NSString *property, BOOL *stop) {
        [value setValue:[avObject objectForKey:property] forKey:property];
    }];
    
    return value;
}

+ (AMapPOI *)poiWithAVObject:(AVObject *)avObject;
{
    return [self poiWithLocationTable:[LocationTable instaceWithAVObject:avObject]];
}

+ (AMapPOI *)poiWithLocationTable:(LocationTable *)locationTable;
{
    AMapPOI *object = [[AMapPOI alloc] init];
    [object enumeratePropertiesWithBlock:^(NSUInteger idx, NSString *property, BOOL *stop) {
        id value = [locationTable valueForKey:property];
        if (value) {
            [object setValue:value forKey:property];
        }
    }];
    
    object.location = [AMapGeoPoint locationWithLatitude:locationTable.latitude longitude:locationTable.longitude];
    
    if (locationTable.images) {
        NSArray *ay = [NSJSONSerialization JSONObjectWithData:[locationTable.images dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        object.images = [AMapImage mj_objectArrayWithKeyValuesArray:ay];
    }
    
    
    AMapIndoorData *indoorData = [[AMapIndoorData alloc] init];
    indoorData.floor = locationTable.floor;
    indoorData.floorName = locationTable.floorName;
    indoorData.pid = locationTable.pid;
    object.indoorData = indoorData;
    
    AMapPOIExtension *extensionInfo = [[AMapPOIExtension alloc] init];
    extensionInfo.rating = locationTable.rating;
    extensionInfo.cost = locationTable.cost;
    extensionInfo.openTime = locationTable.openTime;
    object.extensionInfo = extensionInfo;
    return object;
}

//- (AMapSearchObject *)getPOI;
//{
//    Class cls = (self.sname || self.subtype) ? AMapSubPOI.class : AMapPOI.class;
//    
//    id value = [[cls alloc] init];
//    
//    [cls enumeratePropertiesWithBlock:^(NSUInteger idx, NSString *property, BOOL *stop) {
//        @try {
//            [value setObject:[self valueForKey:property] forKey:property];
//        } @catch (NSException *exception) {
//            
//        } @finally {
//            
//        }
//    }];
//    
//    return value;
//}

@end
