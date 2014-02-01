//
//  RouteManager.m
//  BeatWalker
//
//  Created by Harlan Haskins on 2/1/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "RouteManager.h"
#import "Route.h"
#import "RouteDataManager.h"

@interface RouteManager ()

@property (nonatomic, readwrite) NSMutableArray *routes;

@end

@implementation RouteManager

+ (instancetype) sharedManager {
    static RouteManager *singleton;
    if (!singleton) {
        singleton = [RouteManager new];
        singleton.routes = [self properRoutes];
    }
    return singleton;
}

+ (NSMutableArray*) properRoutes {
    NSMutableArray *savedRoutes = [RouteDataManager savedRoutes];
    return savedRoutes ? savedRoutes : [NSMutableArray array];
}

- (void) addRoute:(Route*)route {
    if ([self.routes indexOfObject:route] == NSNotFound) {
        [self.routes addObject:route];
        [self saveRoutes];
    }
}

- (void) alphabetize {
    [self.routes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
    }];
    [self saveRoutes];
}

- (BOOL) nameExistsInHistory:(NSString*)name {
    for (Route *route in self.routes) {
        if ([route.name caseInsensitiveCompare:name] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

- (void) deleteRoute:(Route*)route {
    if ([self.routes indexOfObject:route] != NSNotFound) {
        [self.routes removeObject:route];
        [self saveRoutes];
    }
}

- (void) saveRoutes {
    [RouteDataManager saveRoutes:self.routes];
}

@end
