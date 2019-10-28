//
//  BaseViewController.h
//  Xt
//
//  Created by Johnson on 23/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, copy) void(^viewDidLoadComplete)(void);

@end
