//
//  UIView+Tools.h
//  Xt
//
//  Created by Johnson on 31/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)
- (void)addTapGestureToResignFirstResponderComplete:(void(^)(UIView *view))complete;
@end
