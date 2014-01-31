//
//  MusicView.h
//  BeatWalker
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayPauseButton.h"

@class PlayPauseButton;

@protocol MusicViewDelegate <NSObject>

- (void) togglePlayback:(PlayState)state;
- (void) advanceToNextSong;
- (void) returnToPreviousSong;

@end

@interface MusicView : UIView

@property (nonatomic) id<MusicViewDelegate> delegate;

- (SEL) selectorForButtonIndex:(NSInteger)index;

@end
