//
//  BWDynamicViewController.h
//  BeatWalker
//
//  Created by Mihir Singh on 1/31/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWDynamicViewController : UIViewController

- (void) addParallax;
- (void) addInnerSnapBehavior;
- (void) addOuterSnapBehavior;
@property (nonatomic) UIView *contentView;

@end
