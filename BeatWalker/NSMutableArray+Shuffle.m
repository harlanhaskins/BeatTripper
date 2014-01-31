//
//  NSMutableArray+Shuffle.m
//  BeatWalker
//
//  Created by Harlan Haskins on 1/31/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform((u_int32_t)nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (NSMutableArray*) arrayByShufflingContents {
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:self];
    [newArray shuffle];
    return newArray;
}

@end
