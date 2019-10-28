//
//  MACustomPinAnnotationView.h
//  GaodeMap
//
//  Created by Johnson on 2019/8/27.
//  Copyright © 2019 Johnson. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MACustomPinAnnotationView : MAPinAnnotationView
@property (nonatomic, strong, readonly) UILabel *labelName;
@end

NS_ASSUME_NONNULL_END
