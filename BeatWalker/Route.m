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

+ (instancetype) routeWithName:(NSString *)name
{
    Route *newRoute = [Route new];
    
    newRoute.name = name;
    
    return newRoute;
}

-(NSString*) details
{
    return [NSString stringWithFormat:@"~%lu Songs | %@",[[self songNumberAverage] longValue], [self stringForTimeAverage]];
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
    [_times addObject:[NSNumber numberWithDouble:time]];
}

- (NSNumber*) timeAverage
{
    CGFloat sum = 0;
    NSInteger count = 0;
    
    for (NSUInteger time = _times.count; time > (_times.count - 5); time--)
    {
        sum += [_times[time] doubleValue];
        count++;
        
        if(time == 0) break;
    }
    return @(sum/count);
}

-(void) addSongNumber:(NSNumber*)number
{
    [_numberOfSongs addObject:number];
}

-(NSNumber*) songNumberAverage
{
    CGFloat sum = 0;
    NSInteger count = 0;
    
    for (NSUInteger songNumber = _numberOfSongs.count; songNumber > (_numberOfSongs.count - 5); songNumber--)
    {
        sum += [_numberOfSongs[songNumber] doubleValue];
        count++;
        
        if(songNumber == 0) break;
    }
    return @(sum/count);
}



@end
