//
//  UIColor+BeatWalker.m
//  BeatWalker
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "UIColor+BeatWalker.h"

@implementation UIColor (BeatWalker)

+ (UIColor*) beatWalkerBackgroundColor {
    return [UIColor colorWithWhite:0.075 alpha:1.0];
}

+ (UIColor*) beatWalkerSeparatorColor {
    return [UIColor colorWithWhite:0.15 alpha:1.0];
}

+ (UIColor*) beatWalkerTextColor {
    return [UIColor colorWithWhite:0.95 alpha:1.0];
}

+ (UIColor*) beatWalkerSubtleTextColor {
    return [UIColor colorWithWhite:0.35 alpha:1.0];
}

@end
