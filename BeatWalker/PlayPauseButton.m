//
//  PlayPauseButton.m
//  BeatWalker
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "PlayPauseButton.h"

@interface PlayPauseButton ()

@property (nonatomic, readwrite) PlayState playState;

@end

@implementation PlayPauseButton

+ (instancetype) new {
    PlayPauseButton *button = [[PlayPauseButton alloc] init];
    button.playState = PlayStatePaused;
    [button setBackgroundImage:[button imageForCurrentPlayState] forState:UIControlStateNormal];
    [button addTarget:button action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void) didTouchButton {
    if (self.playState == PlayStatePaused) {
        self.playState = PlayStatePlaying;
    }
    else {
        self.playState = PlayStatePaused;
    }
    [self setBackgroundImage:[self imageForCurrentPlayState] forState:UIControlStateNormal];
}

- (UIImage*) imageForCurrentPlayState {
    return self.playState == PlayStatePaused ? [UIImage imageNamed:@"PlayButton"] : [UIImage imageNamed:@"PauseButton"];
}

@end
