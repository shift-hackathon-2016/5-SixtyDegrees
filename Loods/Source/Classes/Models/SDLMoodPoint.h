//
//  SDLMoodPoint.h
//  Loods
//
//  Created by Nikola on 01/06/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface SDLMoodPoint : NSObject

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSNumber *radius;

@end
