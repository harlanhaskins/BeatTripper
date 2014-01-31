//
//  Route.h
//  BeatWalker
//
//  Created by Oliver Barnum on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

+ (instancetype) routeWithName:(NSString*)name;

-(void) addTime:(NSTimeInterval)time;
-(NSNumber*) timeAverage;

-(void) addSongNumber:(NSNumber*)number;
-(NSNumber*) songNumberAverage;

@property (nonatomic, readonly) NSString *details;
@property (nonatomic, readonly) NSString *name;

@end
