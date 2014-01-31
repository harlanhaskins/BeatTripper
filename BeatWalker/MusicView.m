//
//  MusicView.m
//  BeatWalker
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "MusicView.h"
#import "PlayPauseButton.h"

@interface MusicView ()

@property (nonatomic) NSMutableArray *buttons;

@end

@implementation MusicView

+ (instancetype) new {
    MusicView *view = [[MusicView alloc] init];
    NSArray *buttonImageTitles = @[@"PreviousButton", @"PlayButton", @"NextButton"];
    
    view.buttons = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button;
        if (i == 1) {
            button = [PlayPauseButton new];
            [(PlayPauseButton*)button setPlayBackBlock:^(PlayState state) {
                [view.delegate togglePlayback:state];
            }];
        }
        else {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:buttonImageTitles[i]] forState:UIControlStateNormal];
            [button addTarget:view.delegate action:[view selectorForButtonIndex:i] forControlEvents:UIControlEventTouchUpInside];
        }
        button.tag = i;
        [button sizeToFit];
        [view addSubview:button];
        [view.buttons addObject:button];
    }
    return view;
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

@end
