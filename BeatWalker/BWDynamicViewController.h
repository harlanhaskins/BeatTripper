//
//  BWDynamicViewController.h
//  BeatTripper
//
//  Created by Mihir Singh on 1/31/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <UIKit/UIKit.h>

@interface BWDynamicViewController : UIViewController

- (void) addParallax;
- (void) addInnerSnapBehavior;
- (void) addOuterSnapBehavior;
@property (nonatomic) UIView *contentView;
@property (nonatomic, readonly) BOOL supportsPhysics;

@end
