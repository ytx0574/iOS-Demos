//
//  HUDHelper.m
//  EG
//
//  Created by jsonlong on 16/4/22.
//  Copyright © 2016年 zsgf. All rights reserved.
//

#import "HUDHelper.h"
#import "MBProgressHUD.h"

@implementation HUDHelper

+ (UIWindow *) mainWindow{
    return [[[UIApplication sharedApplication] delegate] window];
}

//+ (AppDelegate *)delegate
//{
//    return (AppDelegate *)[UIApplication sharedApplication].delegate;
//}

#pragma mark - GCD

+ (void)runInMainQueue:(void (^)(void))queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

+ (void)runInGlobalQueue:(void (^)(void))queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

+ (void)runAfterSecs:(float)secs block:(void (^)(void))block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

#pragma mark - Hud

+ (void)showHudWithDuration:(NSString *)message{
    [HUDHelper runInMainQueue:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HUDHelper.mainWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = message;
        double delayInSeconds = 1.6;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideAllHUDsForView:HUDHelper.mainWindow animated:YES];
        });
    }];
}

+ (void)toast:(NSString *)message{
    [HUDHelper runInMainQueue:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HUDHelper.mainWindow animated:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:hud action:@selector(removeFromSuperview)];
        [hud addGestureRecognizer:tap];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = message;
        double delayInSeconds = 1.8;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:HUDHelper.mainWindow animated:YES];
        });
    }];
}

+ (void)toast:(NSString *)message block:(void (^)(void))block{
    [HUDHelper runInMainQueue:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HUDHelper.mainWindow animated:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:hud action:@selector(removeFromSuperview)];
        [hud addGestureRecognizer:tap];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = message;
        double delayInSeconds = 1.6f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [MBProgressHUD hideAllHUDsForView:HUDHelper.mainWindow animated:YES];
            [MBProgressHUD hideHUDForView:HUDHelper.mainWindow animated:YES];
            if(block){
                block();
            }
        });
    }];
}

+ (void)toastLongMessage:(NSString *)message block:(void (^)(void))block{
    [HUDHelper runInMainQueue:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HUDHelper.mainWindow animated:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:hud action:@selector(removeFromSuperview)];
        [hud addGestureRecognizer:tap];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = message;
        double delayInSeconds = 1.6f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:HUDHelper.mainWindow animated:YES];
            if(block){
                block();
            }
        });
    }];
}

+ (void)showHudWithDuration:(NSString *)message :(double)delay{
    [HUDHelper runInMainQueue:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HUDHelper.mainWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        double delayInSeconds = delay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:HUDHelper.mainWindow animated:YES];
        });
    }];
}

+ (void)showHud:(NSString *)message{
    [HUDHelper runInMainQueue:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:HUDHelper.mainWindow animated:YES];
        hud.labelText = message;
//        hud.color = [UIColor blackColor];
//        hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
//        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

+ (void)showHud:(NSString *)message inView:(UIView *)view{
    [HUDHelper runInMainQueue:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = message;
    }];
}

+ (void)hideHud{
    [HUDHelper runInMainQueue:^{
        [MBProgressHUD hideHUDForView:HUDHelper.mainWindow animated:YES];
    }];
}

+(void)hideHudFromView:(UIView*)view{
    [HUDHelper runInMainQueue:^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    }];
}

+ (void)hideHudblock:(void (^)(void))block{
    [HUDHelper runInGlobalQueue:^{
        [MBProgressHUD hideHUDForView:HUDHelper.mainWindow animated:YES];
        [HUDHelper runInMainQueue:^{
            block();
        }];
    }];
}

@end
