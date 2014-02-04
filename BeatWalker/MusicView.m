//
//  MusicView.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "MusicView.h"
#import "PlayPauseButton.h"

@interface MusicView ()

@property (nonatomic) NSMutableArray *buttons;

@end

@implementation MusicView

- (void) setDelegate:(id<MusicViewDelegate>)delegate {
    _delegate = delegate;
    NSArray *buttonImageTitles = @[@"PreviousButton", @"PlayButton", @"NextButton"];
    
    self.buttons = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button;
        if (i == 1) {
            button = [PlayPauseButton new];
            [(PlayPauseButton*)button setPlayBackBlock:^(PlayState state) {
                [self.delegate togglePlayback:state];
            }];
        }
        else {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:buttonImageTitles[i]] forState:UIControlStateNormal];
            [button addTarget:self.delegate action:[self selectorForButtonIndex:i] forControlEvents:UIControlEventTouchUpInside];
        }
        button.tag = i;
        [button sizeToFit];
        [self addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat buttonCenterX = self.width / 4;
    for (UIButton *button in self.buttons) {
        [button centerToParent];
        button.centerX = (buttonCenterX * (button.tag + 1));
    }
}

- (SEL) selectorForButtonIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @selector(returnToPreviousSong);
            break;
        case 1:
            return @selector(togglePlayback:);
            break;
        case 2:
            return @selector(advanceToNextSong);
            break;
        default:
            return nil;
            break;
    }
}

- (void) enableButtons {
    for (UIButton *button in self.buttons) {
        button.enabled = YES;
    }
}

- (void) disableButtons {
    for (UIButton *button in self.buttons) {
        button.enabled = NO;
    }
}

@end
