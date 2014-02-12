//
//  BWDynamicViewController.m
//  BeatTripper
//
//  Created by Mihir Singh on 1/31/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "BWDynamicViewController.h"

@interface BWDynamicViewController ()

@property (nonatomic) UIDynamicAnimator *animator;

@end

@implementation BWDynamicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.contentView];
    
    CGRect contentFrame = self.view.frame;
    contentFrame.origin.x += contentFrame.size.width;
    contentFrame.origin.y += contentFrame.size.height;
    self.contentView = self.supportsPhysics ? [[UIView alloc] initWithFrame:contentFrame] : self.view;
    self.contentView.backgroundColor = [UIColor beatTripperBackgroundColor];
    if (self.contentView != self.view) {
        [self.view addSubview:self.contentView];
    }
    
    [self addParallax];
	// Do any additional setup after loading the view.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.supportsPhysics) {
        CGRect contentFrame = self.view.frame;
        contentFrame.origin.x -= contentFrame.size.width;
        contentFrame.origin.y -= contentFrame.size.height;
        self.contentView.frame = contentFrame;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.supportsPhysics) {
        [self performSelector:@selector(addInnerSnapBehavior) withObject:nil afterDelay:0.25];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addInnerSnapBehavior {
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self.contentView snapToPoint:self.view.center];
    [self.animator addBehavior:snapBehavior];
}

- (void) addOuterSnapBehavior {
    [self.animator removeAllBehaviors];
    if (self.supportsPhysics) {
        CGPoint outerSnap;
        outerSnap.x = self.view.centerX - self.view.width;
        outerSnap.y = self.view.centerY;
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self.contentView snapToPoint:outerSnap];
        [self.animator addBehavior:snapBehavior];
    }
}

- (void) addParallax {
    
    NSInteger relativeAbsoluteValue = 15;
    
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-relativeAbsoluteValue);
    verticalMotionEffect.maximumRelativeValue = @(relativeAbsoluteValue);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-relativeAbsoluteValue);
    horizontalMotionEffect.maximumRelativeValue = @(relativeAbsoluteValue);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.contentView addMotionEffect:group];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL) supportsPhysics {
    NSString *modelIdentifier = [[UIDevice currentDevice] modelIdentifier];
    return (([modelIdentifier rangeOfString:@"iPad4,"].location != NSNotFound)   ||
            ([modelIdentifier rangeOfString:@"iPod5,"].location != NSNotFound) ||
            ([modelIdentifier rangeOfString:@"iPhone5,"].location != NSNotFound) ||
            ([modelIdentifier rangeOfString:@"iPhone6,"].location != NSNotFound));
}

@end
