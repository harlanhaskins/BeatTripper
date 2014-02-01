//
//  RouteManager.h
//  BeatWalker
//
//  Created by Harlan Haskins on 2/1/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Route;

@interface RouteManager : NSObject

+ (instancetype) sharedManager;
- (void) addRoute:(Route*)route;
- (Route*) routeAtIndex:(NSUInteger)index;
- (NSInteger) numberOfRoutes;
- (void) addTime:(NSTimeInterval)time toRoute:(Route*)route;
- (void) addSongAmount:(double)songAmount toRoute:(Route*)route;

@property (nonatomic, readonly) NSMutableArray *routes;

@end
