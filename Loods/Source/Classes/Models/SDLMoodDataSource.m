//
//  SDLMoodDataSource.m
//  Loods
//
//  Created by Nikola on 01/06/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import "SDLMoodDataSource.h"

@interface SDLMoodDataSource ()

@property (strong, nonatomic) NSArray *points;

@end

@implementation SDLMoodDataSource

+ (SDLMoodDataSource *)sharedDataSource
{
    static SDLMoodDataSource *sharedObject = nil;
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        sharedObject = [[super allocWithZone:nil] init];
        
        [sharedObject loadPoints];
    });
    return sharedObject;
}

- (void)loadPoints
{
    NSMutableArray *tempPoints = [NSMutableArray array];
    
    NSArray *locations = @[[[CLLocation alloc] initWithLatitude:-43.501892 longitude:16.447919],
                           [[CLLocation alloc] initWithLatitude:-43.505691 longitude:16.440727],
                           [[CLLocation alloc] initWithLatitude:-43.520762 longitude:16.430933],
                           [[CLLocation alloc] initWithLatitude:-43.508885 longitude:16.403093],
                           [[CLLocation alloc] initWithLatitude:-43.512443 longitude:16.466291],
                           [[CLLocation alloc] initWithLatitude:-43.524324 longitude:16.444700],
                           [[CLLocation alloc] initWithLatitude:-43.519721 longitude:16.473004],
                           [[CLLocation alloc] initWithLatitude:-43.505550 longitude:16.469996],
                           [[CLLocation alloc] initWithLatitude:-43.511268 longitude:16.449774],
                           [[CLLocation alloc] initWithLatitude:-43.503898 longitude:16.429299],
                           [[CLLocation alloc] initWithLatitude:-43.510072 longitude:16.425320],
                           [[CLLocation alloc] initWithLatitude:-43.527816 longitude:16.450174]];
    
    for(CLLocation *location in locations){
        SDLMoodPoint *point = [[SDLMoodPoint alloc] init];
        point.location = location;
        point.radius = @(100000);
        
        NSUInteger index = [locations indexOfObject:location];
        
        if(index < 5){
            point.color = [self positiveMoodColor];
        }
        else if(index < 9){
            point.color = [self negativeMoodColor];
        }
        else{
            point.color = [self neutralMoodColor];
        }
        
        [tempPoints addObject:point];
    }
    
    self.points = [tempPoints copy];
}

- (UIColor *)positiveMoodColor
{
    return [UIColor colorWithRed:50.0/255.0 green:198.0/255.0 blue:53.0/255.0 alpha:1.0];
}
- (UIColor *)neutralMoodColor
{
    return [UIColor colorWithRed:247.0/255.0 green:174.0/255.0 blue:0 alpha:1.0];
}

- (UIColor *)negativeMoodColor
{
    return [UIColor colorWithRed:228.0/255.0 green:72.0/255.0 blue:35.0/255.0 alpha:1.0];
}

- (NSArray *)moodPoints
{
    return self.points;
}

@end
