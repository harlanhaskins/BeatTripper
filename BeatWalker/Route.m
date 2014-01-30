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

@property (nonatomic) NSString *pointA;
@property (nonatomic) NSString *pointB;

@end

@implementation Route

+ (instancetype) routeWithPointA:(NSString*)pointA pointB:(NSString*)pointB
{
    Route *newRoute = [Route new];
    
    newRoute.pointA = pointA;
    newRoute.pointB = pointB;
    
    return newRoute;
}

-(void) addTime:(NSTimeInterval)time
{
    [_times addObject:[NSNumber numberWithDouble:time]];
}

-(NSNumber*) timeAverage
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
