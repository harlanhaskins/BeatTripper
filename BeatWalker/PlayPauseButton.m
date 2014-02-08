//
//  PlayPauseButton.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "PlayPauseButton.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayPauseButton ()

@property (nonatomic, readwrite) PlayState playState;

@end

@implementation PlayPauseButton

+ (instancetype) new {
    PlayPauseButton *button = [[PlayPauseButton alloc] init];
    button.playState = PlayStatePaused;
    [button setBackgroundImage:[button imageForCurrentPlayState]
                      forState:UIControlStateNormal];
    [button addTarget:button action:@selector(didTouchButton)
     forControlEvents:UIControlEventTouchUpInside];
    
    if (!TARGET_IPHONE_SIMULATOR) {
        [[NSNotificationCenter defaultCenter] addObserver:button
                                                 selector:@selector(playBackChanged)
                                                     name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                   object:nil];
    }
    return button;
}

- (void) playBackChanged {
    MPMusicPlaybackState state = [[MPMusicPlayerController iPodMusicPlayer] playbackState];
    self.playState = (state == MPMusicPlaybackStatePlaying) ? PlayStatePlaying : PlayStatePaused;
}

- (void) setPlayState:(PlayState)playState {
    _playState = playState;
    [self setBackgroundImage:[self imageForCurrentPlayState] forState:UIControlStateNormal];
}
        
        
- (void) didTouchButton {
    if (self.playState == PlayStatePaused) {
        self.playState = PlayStatePlaying;
    }
    else {
        self.playState = PlayStatePaused;
    }
    self.playBackBlock(self.playState);
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object:nil];
}

- (UIImage*) imageForCurrentPlayState {
    return self.playState == PlayStatePaused ? [UIImage imageNamed:@"PlayButton"] : [UIImage imageNamed:@"PauseButton"];
}

@end
