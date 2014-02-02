//
//  Route.m
//  BeatWalker
//
//  Created by Oliver Barnum on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
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

+ (instancetype) routeWithName:(NSString *)name
{
    Route *newRoute = [Route new];
    
    newRoute.name = name;
    newRoute.songAmounts = [NSMutableArray array];
    newRoute.times = [NSMutableArray array];
    
    return newRoute;
}

-(NSString*) details
{
    return [NSString stringWithFormat:@"%.1f Songs | %@", [self songNumberAverage], [self stringForTimeAverage]];
}

- (NSString*) stringForTimeAverage {
    return [self stringForTimeInterval:[self timeAverage]];
}

-(NSString*)stringForTimeInterval:(NSTimeInterval)timeInterval{
    NSInteger hours = floor(timeInterval /  (60 * 60) );
    
    CGFloat minute_divisor = (NSInteger)timeInterval % (60 * 60);
    NSInteger minutes = floor(minute_divisor / 60);
    
    CGFloat seconds_divisor = (NSInteger)timeInterval % 60;
    NSInteger seconds = ceil(seconds_divisor);
    
    NSString *hoursString = hours > 0 ? [NSString stringWithFormat:@"%li:", (long)hours] : @"";
    
    NSString *intervalString = [NSString stringWithFormat:@"%@%li:%02li", hoursString, (long)minutes, (long)seconds];
    
    return intervalString;
}

-(void) addTime:(NSTimeInterval)time
{
    [self.times addObject:@(time)];
}

- (NSTimeInterval) timeAverage
{
    CGFloat sum = 0;
    const NSUInteger numberOfItemsToCheck = 5;
    
    NSInteger time = self.times.count - numberOfItemsToCheck;
    if (time < 0) {
        time = 0;
    }
    
    while (time < self.times.count)
    {
        NSInteger timeIndex = self.times.count - time - 1;
        if (timeIndex <= 0) break;
        
        sum += [self.times[time] doubleValue];
        time++;
    }
    return sum/numberOfItemsToCheck;
}

-(void) addSongNumber:(NSNumber*)number
{
    [self.songAmounts addObject:number];
}

-(double) songNumberAverage
{
    CGFloat sum = 0;
    const NSInteger numberOfItemsToCheck = 5;
    
    NSInteger time = self.times.count - numberOfItemsToCheck;
    if (time < 0) {
        time = 0;
    }
    
    while (time < self.songAmounts.count)
    {
        NSInteger timeIndex = self.times.count - time - 1;
        if (timeIndex <= 0) break;
        
        sum += [self.songAmounts[time] doubleValue];
        time++;
    }
    return sum/numberOfItemsToCheck;
}

@end
