//
//  AddressDetailViewController.h
//  GaodeMap
//
//  Created by Johnson on 2019/8/26.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MACustomPointAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressDetailViewController : UIViewController
@property (nonatomic, strong) MACustomPointAnnotation *pointAnnotation;
@end

NS_ASSUME_NONNULL_END
