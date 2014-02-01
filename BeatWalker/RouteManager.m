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
    NSRegularExpression *removeNumbers = [NSRegularExpression regularExpressionWithPattern:@"\\s\\([0|9]\\)" options:0 error:nil];
    name = [removeNumbers stringByReplacingMatchesInString:name
                                                   options:0
                                                     range:NSMakeRange(0, [name length])
                                              withTemplate:@""];
    
    for (Route *route in self.routes) {
        if ([route.name caseInsensitiveCompare:name] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

- (NSString*) nextAvailableRouteNameWithPrefix:(NSString*)prefix {
    NSString *newString = [prefix copy];
    NSInteger incrementer = 1;
    while ([self nameExistsInHistory:newString]) {
        newString = [NSString stringWithFormat:@"%@ (%li)", prefix, (long)incrementer];
        incrementer++;
    }
    return newString;
}

- (Route*) routeAtIndex:(NSUInteger)index {
    return self.routes[index];
}

- (NSInteger) numberOfRoutes {
    return self.routes.count;
}

- (void) addTime:(NSTimeInterval)time toRoute:(Route*)route {
    [route addTime:time];
    [self saveRoutes];
}

- (void) addSongAmount:(double)songAmount toRoute:(Route*)route {
    [route addSongNumber:@(songAmount)];
    [self saveRoutes];
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

- (void) deleteAllRoutes {
    self.routes = [NSMutableArray array];
    [self saveRoutes];
}

@end
