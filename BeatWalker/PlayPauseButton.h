//
//  PlayPauseButton.h
//  BeatWalker
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
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
