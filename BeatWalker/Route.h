//
//  Route.h
//  BeatTripper
//
//  Created by Oliver Barnum on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject<NSCoding>

+ (instancetype) routeWithName:(NSString*)name;

-(void) addTime:(NSTimeInterval)time;
-(NSTimeInterval) timeAverage;

-(void) addSongNumber:(NSNumber*)number;
-(double) songNumberAverage;

@property (nonatomic, readonly) NSString *details;
@property (nonatomic, readonly) NSString *name;

@end
