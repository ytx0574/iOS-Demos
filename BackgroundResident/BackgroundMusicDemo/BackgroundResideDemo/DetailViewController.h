//
//  DetailViewController.h
//  BackgroundResideDemo
//
//  Created by Johnson on 2017/5/4.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

