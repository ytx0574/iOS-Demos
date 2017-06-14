//
//  DetailViewController.h
//  NS_DESIGNATED_INITIALIZER
//
//  Created by Johnson on 11/06/2017.
//  Copyright © 2017 Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

