//
//  Route.m
//  BeatTripper
//
//  Created by Oliver Barnum on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "Route.h"

@interface Route ()

@property (nonatomic) NSMutableArray *songAmounts;
@property (nonatomic) NSMutableArray *times;

@property (nonatomic) NSString *name;

@end

@implementation Route

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.songAmounts forKey:@"numberOfSongs"];
    [aCoder encodeObject:self.times forKey:@"times"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.songAmounts = [aDecoder decodeObjectForKey:@"numberOfSongs"];
        self.times = [aDecoder decodeObjectForKey:@"times"];
    }
    return self;
}

+ (instancetype) routeWithName:(NSString *)name {
    Route *newRoute = [Route new];
    
    newRoute.name = name;
    newRoute.songAmounts = [NSMutableArray array];
    newRoute.times = [NSMutableArray array];
    
    return newRoute;
}

-(NSString*) details {
    return [NSString stringWithFormat:@"%.1f Songs | %@", [self songNumberAverage], [self stringForTimeAverage]];
}

- (NSString*) stringForTimeAverage {
    return [self stringForTimeInterval:[self timeAverage]];
}

-(NSString*)stringForTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger hours = floor(timeInterval /  (60 * 60) );
    
    CGFloat minute_divisor = (NSInteger)timeInterval % (60 * 60);
    NSInteger minutes = floor(minute_divisor / 60);
    
    CGFloat seconds_divisor = (NSInteger)timeInterval % 60;
    NSInteger seconds = ceil(seconds_divisor);
    
    NSString *hoursString = hours > 0 ? [NSString stringWithFormat:@"%li:", (long)hours] : @"";
    
    NSString *intervalString = [NSString stringWithFormat:@"%@%li:%02li", hoursString, (long)minutes, (long)seconds];
    
    return intervalString;
}

-(void) addTime:(NSTimeInterval)time {
    [self.times addObject:@(time)];
}

- (NSTimeInterval) timeAverage {
    return [self movingAverageOfArray:self.times withNumberOfItems:5];
}

- (double) movingAverageOfArray:(NSArray*)array withNumberOfItems:(NSInteger)items {
    NSInteger numberOfItems = MIN(array.count, items);
    double average = 0.0;
    for (int i = 0; i < numberOfItems; i++) {
        average += [array[array.count - 1 - i] doubleValue];
    }
    if (numberOfItems > 0) {
        average /= numberOfItems;
    }
    return average;
}

-(void) addSongNumber:(NSNumber*)number {
    [self.songAmounts addObject:number];
}

-(double) songNumberAverage {
    return [self movingAverageOfArray:self.songAmounts withNumberOfItems:5];
}

@end
