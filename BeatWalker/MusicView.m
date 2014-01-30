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

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat buttonCenterX = self.width / 4;
        
        NSArray *buttonImageTitles = @[@"PreviousButton", @"PlayButton", @"NextButton"];
        
        self.buttons = [NSMutableArray array];
        
        for (int i = 0; i < 3; i++) {
            UIButton *button;
            if (i == 1) {
                button = [PlayPauseButton new];
            }
            else {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[UIImage imageNamed:buttonImageTitles[i]] forState:UIControlStateNormal];
            }
            [button sizeToFit];
            [self addSubview:button];
            [button centerToParent];
            button.centerX = (buttonCenterX * (i + 1));
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
