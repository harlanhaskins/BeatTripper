//
//  UIColor+BeatTripper.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import "UIColor+BeatTripper.h"

@implementation UIColor (BeatTripper)

+ (UIColor*) beatTripperBackgroundColor {
    return [UIColor colorWithWhite:0.075 alpha:1.0];
}

+ (UIColor*) beatTripperSeparatorColor {
    return [UIColor colorWithWhite:0.15 alpha:1.0];
}

+ (UIColor*) beatTripperTextColor {
    return [UIColor colorWithWhite:0.95 alpha:1.0];
}

+ (UIColor*) beatTripperUnhighlightedTextColor {
    return [UIColor colorWithWhite:0.5 alpha:1.0];
}

+ (UIColor*) beatTripperSubtleTextColor {
    return [UIColor colorWithWhite:0.35 alpha:1.0];
}

@end
