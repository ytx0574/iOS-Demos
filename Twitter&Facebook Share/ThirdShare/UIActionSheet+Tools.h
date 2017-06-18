//
//  UIActionSheet+Tools.h
//  AlertView
//
//  Created by Johnson on 3/25/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Tools)

- (void)showInView:(UIView *)showInView complete:(void(^)(NSInteger buttonIndex, UIActionSheet *actionSheet))complete;

@end
