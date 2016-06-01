//
//  SDLMoodPoint.m
//  Loods
//
//  Created by Nikola on 01/06/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import "SDLMoodPoint.h"

@implementation SDLMoodPoint

- (NSString *)description
{
    return [NSString stringWithFormat:@"Location: (%f, %f)", self.location.coordinate.latitude, self.location.coordinate.longitude];
}

@end
