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

@class PlayPauseButton;
@protocol PlayPauseButtonDelegate <NSObject>

- (void)playPauseButton:(PlayPauseButton *)button didChangePlayState:(PlayState)state;

@end

@interface PlayPauseButton : UIButton

@property (nonatomic, readonly) PlayState playState;
@property (nonatomic) id<PlayPauseButtonDelegate> delegate;

@end
