//
//  OpenMap.m
//  Xt
//
//  Created by Johnson on 30/03/2018.
//  Copyright © 2018 99. All rights reserved.
//

#import "OpenMap.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NSString * const kAppName = @"JohnsonLocationRecord";
NSString * const kAppURLScheme = @"johnsonlocationrecord";

@implementation OpenMap

+ (void)openMapWithType:(MapType)mapType coordinate:(CLLocationCoordinate2D)coordinate complete:(void(^)(NSError *error))complete;
{
    NSString *urlString;
    switch (mapType) {
        case MapTypeApple:
        {
//            NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=slat,slng",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }
            break;
        case MapTypeGoogle:
        {
            urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving", kAppName, kAppURLScheme, coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
            
        case MapTypeBaidu:
        {
            urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02", coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
            
        case MapTypeGaode:
        {
            urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2", kAppName, kAppURLScheme, coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
            
        default:
            break;
    }
    NSURL *URL = [NSURL URLWithString:urlString];
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        complete ? complete([NSError errorWithDomain:@"无法打开App" code:0 userInfo:nil]) : nil;
        return;
    }
    [[UIApplication sharedApplication] openURL:URL];
}
@end
