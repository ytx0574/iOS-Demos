//
//  LocationTable.h
//  GaodeMap
//
//  Created by Johnson on 2019/8/27.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import "AVObject.h"
#import <AMapSearchKit/AMapCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationTable : AVObject
///POI全局唯一ID
@property (nonatomic, copy)   NSString     *uid;
///名称
@property (nonatomic, copy)   NSString     *name;
///兴趣点类型
@property (nonatomic, copy)   NSString     *type;
///类型编码
@property (nonatomic, copy)   NSString     *typecode;
///经纬度
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
//@property (nonatomic, copy)   AMapGeoPoint *location;
///地址
@property (nonatomic, copy)   NSString     *address;
///电话
@property (nonatomic, copy)   NSString     *tel;
///距中心点的距离，单位米。在周边搜索时有效
@property (nonatomic, assign) NSInteger     distance;
///停车场类型，地上、地下、路边
@property (nonatomic, copy)   NSString     *parkingType;
///商铺id
@property (nonatomic, copy)   NSString     *shopID;

///邮编
@property (nonatomic, copy)   NSString     *postcode;
///网址
@property (nonatomic, copy)   NSString     *website;
///电子邮件
@property (nonatomic, copy)   NSString     *email;
///省
@property (nonatomic, copy)   NSString     *province;
///省编码
@property (nonatomic, copy)   NSString     *pcode;
///城市名称
@property (nonatomic, copy)   NSString     *city;
///城市编码
@property (nonatomic, copy)   NSString     *citycode;
///区域名称
@property (nonatomic, copy)   NSString     *district;
///区域编码
@property (nonatomic, copy)   NSString     *adcode;
///地理格ID
@property (nonatomic, copy)   NSString     *gridcode;
///入口经纬度
//@property (nonatomic, copy)   AMapGeoPoint *enterLocation;
///出口经纬度
//@property (nonatomic, copy)   AMapGeoPoint *exitLocation;
///方向
@property (nonatomic, copy)   NSString     *direction;
///是否有室内地图
@property (nonatomic, assign) BOOL          hasIndoorMap;
///所在商圈
@property (nonatomic, copy)   NSString     *businessArea;
///室内信息
@property (nonatomic, assign) NSInteger floor;
///楼层名称
@property (nonatomic, copy)   NSString  *floorName;
///建筑物ID
@property (nonatomic, copy)   NSString  *pid;
//@property (nonatomic, strong) AMapIndoorData *indoorData;
///子POI列表
//@property (nonatomic, strong) NSArray<AMapSubPOI *> *subPOIs;
///图片列表
@property (nonatomic, strong) NSString *images; //JSONString
//@property (nonatomic, strong) NSArray<AMapImage *> *images;

///扩展信息只有在ID查询时有效
@property (nonatomic, assign) CGFloat  rating;
///人均消费
@property (nonatomic, assign) CGFloat  cost;
///营业时间
@property (nonatomic, copy)   NSString *openTime;
//@property (nonatomic, strong) AMapPOIExtension *extensionInfo;



//@property (nonatomic, copy)   NSString     *uid;
///名称
//@property (nonatomic, copy)   NSString     *name;
///名称简写
@property (nonatomic, copy)   NSString     *sname;
///经纬度
//@property (nonatomic, copy)   AMapGeoPoint *location;
///地址
//@property (nonatomic, copy)   NSString     *address;
///距中心点距离
//@property (nonatomic, assign) NSInteger     distance;
///子POI类型
@property (nonatomic, copy)   NSString     *subtype;


- (void)copyInfoFromPOIInfo:(AMapPOI *)poi;
- (void)cppyInfoFromSubPOIInfo:(AMapSubPOI *)subPOI;

+ (instancetype)instaceWithAVObject:(AVObject *)avObject;

/**不再区分是否为subPOI. 直接返回组装好的POI*/
+ (AMapPOI *)poiWithAVObject:(AVObject *)avObject;
/**不再区分是否为subPOI. 直接返回组装好的POI*/
+ (AMapPOI *)poiWithLocationTable:(LocationTable *)locationTable;
@end

NS_ASSUME_NONNULL_END
