//
//  SelectMedia.m
//  ThirdShare
//
//  Created by Johnson on 10/06/2017.
//  Copyright © 2017 Johnson. All rights reserved.
//

#import "SelectMedia.h"
#import "NSObject+CallBack.h"
#import "AGImagePickerController.h"
#import "AGIPCToolbarItem.h"
#import <AVFoundation/AVFoundation.h>


@implementation SelectMedia

+ (instancetype)shareInstance
{
    static SelectMedia *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}


+ (void)selectVideoWithViewControler:(UIViewController *)vc complete:(void(^)(NSDictionary<NSString *,id> *info))complete
{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.mediaTypes = @[@"public.movie"];//[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerVC.delegate = (id)[SelectMedia shareInstance];
    pickerVC.callBack = complete;
    [vc presentViewController:pickerVC animated:YES completion:nil];
}


+ (void)selectPhotoWithViewControler:(UIViewController *)vc complete:(void(^)(NSDictionary<NSString *,id> *info))complete
{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.allowsEditing = YES;
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVC.mediaTypes = @[@"public.image"];//[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerVC.delegate = (id)[SelectMedia shareInstance];
    pickerVC.callBack = complete;
    [vc presentViewController:pickerVC animated:YES completion:nil];
}

+ (void)selectPhotosWithViewControler:(UIViewController *)vc max:(NSUInteger)max complete:(void(^)(NSArray <UIImage *> *images))complete;
{
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] andSelectionBlock:nil];
    
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Deselect All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];
    
    
    
    AGImagePickerController *imagepicker = [[AGImagePickerController alloc] initWithDelegate:self failureBlock:^(NSError *error) {
        
        [vc dismissViewControllerAnimated:YES completion:nil];
    } successBlock:^(NSArray *info) {
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        [info enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [photos addObject:[SelectMedia fullResolutionImageFromALAsset:obj]];
        }];
        
        complete ? complete(photos) : nil;
        [vc dismissViewControllerAnimated:YES completion:nil];
    } maximumNumberOfPhotosToBeSelected:max shouldChangeStatusBarStyle:YES toolbarItemsForManagingTheSelection:@[selectAll, flexible, flexible, deselectAll] andShouldShowSavedPhotosOnTop:NO];
    
    [vc presentViewController:imagepicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);
//{
//    picker.callBack(image, editingInfo);
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
{
    picker.callBack ? picker.callBack(info) : nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    picker.callBack ? picker.callBack(nil) : nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
