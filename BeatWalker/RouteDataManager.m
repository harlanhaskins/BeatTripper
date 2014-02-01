//
//  CacheManager.m
//  BeatWalker
//
//  Created by Harlan Haskins on 2/1/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "RouteDataManager.h"

@implementation RouteDataManager

+ (void) saveRoutes:(NSMutableArray *)routes {
    [NSKeyedArchiver archiveRootObject:routes toFile:[self routeFilePath]];
}

+ (NSMutableArray*) savedRoutes {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self routeFilePath]];
}

+ (NSString*) routeFilePath {
    return [self documentsDataPathWithPathComponent:@"Routes.bwr"];
}

#pragma mark - Common methods

+ (NSString*) documentsDataPathWithPathComponent:(NSString*)pathComponent {
    NSString *documentsFileName = [[self documentsPath] stringByAppendingPathComponent:pathComponent];
    return documentsFileName;
}

+ (NSString*) documentsPath {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                              inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

@end
