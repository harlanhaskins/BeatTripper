//
//  NewRouteViewController.m
//  BeatTripper
//
//  Created by Harlan Haskins on 2/1/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import "NewRouteViewController.h"
#import "Route.h"

@interface NewRouteViewController ()

@property (nonatomic) UILabel *routeLabel;
@property (nonatomic) UITextField *routeNameTextField;

@property (nonatomic) UIButton *finishButton;
@property (nonatomic) UIButton *cancelButton;

@end

@implementation NewRouteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.routeLabel = [UILabel new];
    self.routeLabel.text = @"Name your New Route";
    self.routeLabel.textColor = [UIColor beatTripperTextColor];
    self.routeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:26.0];
    [self.routeLabel sizeToFit];
    [self.contentView addSubview:self.routeLabel];
    
    self.routeNameTextField = [UITextField new];
    
    UIColor *color = [UIColor beatTripperSubtleTextColor];
    self.routeNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Route"
                                                                                    attributes:@{NSForegroundColorAttributeName: color}];
    self.routeNameTextField.textColor = [UIColor beatTripperTextColor];
    self.routeNameTextField.delegate = self;
    [self.routeNameTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
    [self.contentView addSubview:self.routeNameTextField];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setImage:[UIImage imageNamed:@"CheckButton"] forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton sizeToFit];
    self.finishButton.enabled = NO;
    [self.contentView addSubview:self.finishButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"XButton"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    [self.contentView addSubview:self.cancelButton];
}

- (void) dismiss {
    self.finishedCreatingRouteBlock(nil);
    [self close];
}

- (void) finish {
    Route *route = [Route routeWithName:self.routeNameTextField.text];
    self.finishedCreatingRouteBlock(route);
    [self close];
}

- (void) close {
    [self resignFirstResponder];
    [self addOuterSnapBehavior];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidLayoutSubviews {
    CGFloat padding = 15.0;
    
    [self.routeLabel centerToParent];
    self.routeLabel.y = 50.0;
    
    self.routeNameTextField.height = 44.0;
    self.routeNameTextField.width = self.contentView.width * 0.75;
    [self.routeNameTextField centerToParent];
    self.routeNameTextField.y = self.routeLabel.bottom + padding;
    
//    CGSize buttonSize = self.finishButton.imageView.image.size;
//    buttonSize = CGSizeApplyAffineTransform(buttonSize, CGAffineTransformMakeScale(0.85, 0.85));
//
//    self.finishButton.size =
//    self.cancelButton.size = buttonSize;
    
    [self.finishButton centerToParent];
    [self.cancelButton centerToParent];
    
    self.finishButton.y =
    self.cancelButton.y =
    self.routeNameTextField.bottom + padding;
    
    self.finishButton.right += self.finishButton.width;
    self.cancelButton.x -= self.cancelButton.width;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 1 || (string.length > 0 && ![string isEqualToString:@""])) {
        self.finishButton.enabled = YES;
    }
    else {
        self.finishButton.enabled = NO;
    }
    return YES;
}

@end
