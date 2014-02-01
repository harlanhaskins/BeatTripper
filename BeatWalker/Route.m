//
//  Route.m
//  BeatWalker
//
//  Created by Oliver Barnum on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "Route.h"

@interface Route ()

@property (nonatomic) NSMutableArray *numberOfSongs;
@property (nonatomic) NSMutableArray *times;

@property (nonatomic) NSString *name;

@end

@implementation Route

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.numberOfSongs forKey:@"numberOfSongs"];
    [aCoder encodeObject:self.times forKey:@"times"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.numberOfSongs = [aDecoder decodeObjectForKey:@"numberOfSongs"];
        self.times = [aDecoder decodeObjectForKey:@"times"];
    }
    return self;
}

+ (instancetype) routeWithName:(NSString *)name
{
    Route *newRoute = [Route new];
    
    newRoute.name = name;
    newRoute.numberOfSongs = [NSMutableArray array];
    newRoute.times = [NSMutableArray array];
    
    return newRoute;
}

-(NSString*) details
{
    return [NSString stringWithFormat:@"%lu Songs | %@",[[self songNumberAverage] longValue], [self stringForTimeAverage]];
}

- (NSString*) stringForTimeAverage {
    return [self stringForTimeInterval:[[self timeAverage] doubleValue]];
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

- (NSNumber*) timeAverage
{
    CGFloat sum = 0;
    const NSInteger numberOfItemsToCheck = 5;
    
    for (NSUInteger time = self.times.count; time > (self.times.count - numberOfItemsToCheck); time--)
    {
        sum += [self.times[time] doubleValue];
        
        if (time == 0) break;
    }
    return @(sum/numberOfItemsToCheck);
}

-(void) addSongNumber:(NSNumber*)number
{
    [self.numberOfSongs addObject:number];
}

-(NSNumber*) songNumberAverage
{
    CGFloat sum = 0;
    const NSInteger numberOfItemsToCheck = 5;
    
    for (NSUInteger songNumber = self.numberOfSongs.count; songNumber > (self.numberOfSongs.count - 5); songNumber--)
    {
        sum += [self.numberOfSongs[songNumber] doubleValue];
        
        if (songNumber == 0) break;
    }
    return @(sum/numberOfItemsToCheck);
}

@end
