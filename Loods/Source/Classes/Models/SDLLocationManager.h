//
//  SDLLocationManager.h
//  Loods
//
//  Created by Nikola on 31/05/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol SDLLocationManagerDelegate <NSObject>

@optional

- (void)didUpdateCurrentLocation:(CLLocation *)location;

- (void)didUpdatePlacemark:(CLPlacemark *)placemark;

@end

@interface SDLLocationManager : NSObject

@property (weak, nonatomic) id<SDLLocationManagerDelegate> delegate;

+ (SDLLocationManager *)sharedManager;

- (void)updateCurrentLocation;

- (void)updatePlacemarkForLocation:(CLLocation *)location;

@end
