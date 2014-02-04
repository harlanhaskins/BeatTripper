//
//  PlayPauseButton.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <UIKit/UIKit.h>

typedef enum {
    PlayStatePlaying,
    PlayStatePaused
} PlayState;

@interface PlayPauseButton : UIButton

@property (nonatomic, readonly) PlayState playState;

@property (nonatomic, copy) void (^playBackBlock)(PlayState state);

@end
