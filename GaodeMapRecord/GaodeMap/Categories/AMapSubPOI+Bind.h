//
//  AMapSubPOI+Bind.h
//  GaodeMap
//
//  Created by Johnson on 2019/8/27.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import <AMapSearchKit/AMapCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMapSubPOI (Bind)
@property (nonatomic, weak) AMapPOI *superPOI;
@end

NS_ASSUME_NONNULL_END
