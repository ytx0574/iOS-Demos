//
//  Header.h
//  Xt
//
//  Created by Johnson on 24/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <ReactiveObjC/ReactiveObjC.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import <BmobSDK/Bmob.h>
#import "UIAlertView+Tools.h"
#import "ConstKeys.h"


/**if return 判定*/
#define IF_RETURN(condition, code)                                     if (condition) { code; return; }
/**if return value 判定*/
#define IF_RETURN_VALUE(condition, code, returnValue)                  if (condition) { code; return returnValue; }


extern NSString *kCellIdentifier;


#define STORYBOARDWITHNAME(name)                  [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]]
#define STORYBOARD_MAIN                           STORYBOARDWITHNAME(@"Main")
#define INSTANCEFROMMAINWITHCLASS(class)          [STORYBOARD_MAIN instantiateViewControllerWithIdentifier:NSStringFromClass(class)]

#define RESIGN_FIRST_RESPONDER                    [[UIApplication sharedApplication].keyWindow endEditing:YES]


