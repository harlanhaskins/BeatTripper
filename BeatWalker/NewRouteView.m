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

+ (instancetype) new {
    NewRouteView *view = [[NewRouteView alloc] init];
    UIColor *color = [UIColor beatTripperSubtleTextColor];
    view.routeNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Route Name"
                                                                                    attributes:@{NSForegroundColorAttributeName: color}];
    view.routeNameTextField.textColor = [UIColor beatTripperTextColor];
    view.routeNameTextField.delegate = view;
    [view.routeNameTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:1];
    [view addSubview:view.routeNameTextField];
    
    view.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view.finishButton setImage:[UIImage imageNamed:@"CheckButton"] forState:UIControlStateNormal];
    [view.finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [view.finishButton sizeToFit];
    view.finishButton.enabled = NO;
    [view addSubview:view.finishButton];
    
    view.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view.cancelButton setImage:[UIImage imageNamed:@"XButton"] forState:UIControlStateNormal];
    [view.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [view.cancelButton sizeToFit];
    [view addSubview:view.cancelButton];
    
    return view;
}

- (void) layoutSubviews {
    CGFloat padding = 15.0;
    
    self.routeNameTextField.height = 44.0;
    self.routeNameTextField.width = self.width * 0.75;
    [self.routeNameTextField centerToParent];
    
    self.routeNameTextField.y -= (self.finishButton.height / 2) - padding;
    
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

- (BOOL) becomeFirstResponder {
    return [self.routeNameTextField becomeFirstResponder];
}

@end
