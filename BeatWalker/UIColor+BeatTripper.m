//
//  UIColor+BeatTripper.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import "UIColor+BeatTripper.h"

@implementation UIColor (BeatTripper)

+ (instancetype) beatTripperBackgroundColor {
    return [UIColor colorWithWhite:0.075 alpha:1.0];
}

+ (instancetype) beatTripperSeparatorColor {
    return [UIColor colorWithWhite:0.15 alpha:1.0];
}

+ (instancetype) beatTripperTextColor {
    return [UIColor colorWithWhite:0.95 alpha:1.0];
}

+ (instancetype) beatTripperUnhighlightedTextColor {
    return [UIColor colorWithWhite:0.5 alpha:1.0];
}

+ (instancetype) beatTripperSubtleTextColor {
    return [UIColor colorWithWhite:0.35 alpha:1.0];
}

+ (instancetype) beatTripperGreenColor {
    return [UIColor colorWithRed:0.00/255.0 green:166.0/255.0 blue:81.0/255.0 alpha:1.000];
}

@end
