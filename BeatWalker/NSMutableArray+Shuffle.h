//
//  NSMutableArray+Shuffle.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/31/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Shuffle)

- (NSMutableArray*) arrayByShufflingContents;
- (void) shuffle;

@end
