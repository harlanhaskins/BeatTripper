//
//  BWDynamicViewController.m
//  BeatWalker
//
//  Created by Mihir Singh on 1/31/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "BWDynamicViewController.h"

@interface BWDynamicViewController ()

@property (nonatomic) UIDynamicAnimator *animator;

@end

@implementation BWDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.contentView];
    
    CGRect contentFrame = self.view.frame;
    contentFrame.origin.x += contentFrame.size.width;
    contentFrame.origin.y += contentFrame.size.height;
    self.contentView = [[UIView alloc] initWithFrame:contentFrame];
    self.contentView.backgroundColor = [UIColor beatWalkerBackgroundColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    [self addParallax];
	// Do any additional setup after loading the view.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect contentFrame = self.view.frame;
    contentFrame.origin.x -= contentFrame.size.width;
    contentFrame.origin.y -= contentFrame.size.height;
    self.contentView.frame = contentFrame;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addInnerSnapBehavior];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

@end
