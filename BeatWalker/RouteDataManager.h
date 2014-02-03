//
//  CacheManager.h
//  BeatTripper
//
//  Created by Harlan Haskins on 2/1/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

@interface RouteDataManager : NSObject

+ (void) saveRoutes:(NSMutableArray*)routes;
+ (NSMutableArray*) savedRoutes;

@end
