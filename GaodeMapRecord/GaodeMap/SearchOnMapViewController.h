//
//  SearchOnMapViewController.h
//  
//
//  Created by Johnson on 2019/8/23.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchOnMapViewController : UIViewController
/**默认的关键字搜索*/
@property (nonatomic, copy) NSString *defatultSearchText;
/**显示其subPOIs*/
@property (nonatomic, strong) AMapPOI *poi;
/**显示所有POI*/
@property (nonatomic, strong) NSArray <AMapPOI *> *pois;
@end

NS_ASSUME_NONNULL_END
