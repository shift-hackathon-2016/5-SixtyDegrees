//
//  SDLLocationManager.m
//  Loods
//
//  Created by Nikola on 31/05/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import "SDLLocationManager.h"

@interface SDLLocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;

@end

@implementation SDLLocationManager

+ (SDLLocationManager *)sharedManager
{
    static SDLLocationManager *sharedObject = nil;
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        sharedObject = [[super allocWithZone:nil] init];
        
        sharedObject.manager = [[CLLocationManager alloc] init];
        sharedObject.manager.delegate = sharedObject;
        sharedObject.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    });
    return sharedObject;
}

- (void)updateCurrentLocation
{
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.manager requestWhenInUseAuthorization];
    }
    else{
        [self.manager requestLocation];
    }
}

#pragma mark - CLLocationManager Delegate -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.cachedLocation = locations.firstObject;
    
    if([self.delegate respondsToSelector:@selector(didUpdateCurrentLocation:)]){
        [self.delegate didUpdateCurrentLocation:locations.firstObject];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.cachedLocation = nil;
    
    if([self.delegate respondsToSelector:@selector(didUpdateCurrentLocation:)]){
        [self.delegate didUpdateCurrentLocation:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.manager requestLocation];
    }
}

- (void)updatePlacemarkForLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(placemarks.count > 0){
            if([self.delegate respondsToSelector:@selector(didUpdatePlacemark:)]){
                [self.delegate didUpdatePlacemark:placemarks.firstObject];
            }
        }
        else{
            if([self.delegate respondsToSelector:@selector(didUpdatePlacemark:)]){
                [self.delegate didUpdatePlacemark:nil];
            }
        }
    }];
}

@end
