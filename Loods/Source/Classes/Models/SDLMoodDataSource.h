//
//  SDLMoodDataSource.h
//  Loods
//
//  Created by Nikola on 01/06/16.
//  Copyright © 2016 SixtyDegrees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLMoodPoint.h"

@interface SDLMoodDataSource : NSObject

+ (SDLMoodDataSource *)sharedDataSource;

- (NSArray *)moodPoints;

@end
