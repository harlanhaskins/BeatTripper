//
//  NewRouteView.m
//  BeatTripper
//
//  Created by Harlan Haskins on 2/2/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "NewRouteView.h"
#import "Route.h"

@interface NewRouteView ()

@property (nonatomic) UITextField *routeNameTextField;

@property (nonatomic) UIButton *finishButton;
@property (nonatomic) UIButton *cancelButton;

@end

@implementation NewRouteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {UIColor *color = [UIColor beatTripperSubtleTextColor];
        self.routeNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Route Name"
                                                                                        attributes:@{NSForegroundColorAttributeName: color}];
        self.routeNameTextField.textColor = [UIColor beatTripperTextColor];
        self.routeNameTextField.delegate = self;
        [self.routeNameTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:1];
        [self addSubview:self.routeNameTextField];
        
        self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.finishButton setImage:[UIImage imageNamed:@"CheckButton"] forState:UIControlStateNormal];
        [self.finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        [self.finishButton sizeToFit];
        self.finishButton.enabled = NO;
        [self addSubview:self.finishButton];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setImage:[UIImage imageNamed:@"XButton"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton sizeToFit];
        [self addSubview:self.cancelButton];
    }
    return self;
}

- (void) layoutSubviews {
    CGFloat padding = 15.0;
    
    self.routeNameTextField.height = 44.0;
    self.routeNameTextField.width = self.width * 0.75;
    [self.routeNameTextField centerToParent];
    
    self.routeNameTextField.y -= (self.finishButton.height / 2) - padding;
    
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
