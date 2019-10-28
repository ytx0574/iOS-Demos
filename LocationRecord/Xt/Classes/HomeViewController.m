//
//  ViewController.m
//  Xt
//
//  Created by 99 on 06/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Header.h"
#import "UIView+Tools.h"

#import "AddressListViewController.h"
#import "AddressDetailViewController.h"

@interface HomeViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) CLPlacemark *currentPlacemark;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    
    _locationManager.delegate = self;
    _locationManager.distanceFilter=1.0;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [self.view addTapGestureToResignFirstResponderComplete:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (IBAction)clickPosition:(id)sender {
    [_locationManager startUpdatingLocation];
}

- (IBAction)clickAddAddress:(id)sender {
}

- (IBAction)clickPositionList:(id)sender {
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations API_AVAILABLE(ios(6.0), macos(10.9));
{
    [_locationManager stopUpdatingLocation];
    
    _geocoder = _geocoder ?: [[CLGeocoder alloc] init];
    [_geocoder reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        _currentPlacemark = placemarks.firstObject;
        self.textView.text = _currentPlacemark.description;
        
        [UIPasteboard generalPasteboard].string = self.textView.text;
    }];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    [_locationManager stopUpdatingLocation];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"kAddAddress"]) {
        if (!_currentPlacemark) {
            JShowAlertViewMsg(@"请先获取当前位置");
            return NO;
        }
    }
    else if ([identifier isEqualToString:@"kAddressList"]) {
        
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[AddressDetailViewController class]]) {
        
        AddressDetailViewController *addressDetailVC = (AddressDetailViewController *)segue.destinationViewController;
        @weakify(self)
        @weakify(addressDetailVC)
        [addressDetailVC setViewDidLoadComplete:^{
            @strongify(self)
            @strongify(addressDetailVC)

            addressDetailVC.isAdd = YES;
            addressDetailVC.placemark = self.currentPlacemark;
            addressDetailVC.textViewAddress.text = self.currentPlacemark.description;
        }];
    }
    else if ([segue.destinationViewController isKindOfClass:[AddressListViewController class]]) {
        
    }
}

@end
