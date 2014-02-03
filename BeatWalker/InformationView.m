//
//  InformationView.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "InformationView.h"

@interface InformationView ()

@property (nonatomic) UILabel *numberLabel;
@property (nonatomic) UILabel *typeLabel;

@property (nonatomic) InformationType informationType;

@end

@implementation InformationView

+ (instancetype) viewWithInformationType:(InformationType)type {
    InformationView *view = [[InformationView alloc] init];
    
    view.informationType = type;
    
    view.numberLabel = [UILabel new];
    view.typeLabel = [UILabel new];
    
    view.numberLabel.textColor =
    view.typeLabel.textColor = [UIColor beatTripperTextColor];
    
    [view setType:[view stringFromInformationType:view.informationType]];
    
    view.numberLabel.font = [UIFont boldSystemFontOfSize:48.0];
    view.typeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    
    [view addSubview:view.numberLabel];
    [view addSubview:view.typeLabel];
    [view sizeToFit];
    
    [view setInformation:0.0];
    
    return view;
}

- (NSString *) stringFromInformationType:(InformationType)type {
    switch (type) {
        case InformationTypeNumber:
            return @"Songs";
        case InformationTypeTimeInterval:
            return @"Time";
    }
}

- (void) layoutSubviews {
    [self.numberLabel centerToParent];
    self.numberLabel.y = 0.0;
    [self.typeLabel centerToParent];
    self.typeLabel.y = self.numberLabel.bottom;
    [self sizeToFit];
}

- (void) setType:(NSString*)type {
    self.typeLabel.text = type;
    [self.typeLabel sizeToFit];
    [self layoutSubviews];
}

- (void) setInformation:(double)information {
    switch (self.informationType) {
        case InformationTypeNumber:
            self.numberLabel.text = [NSString stringWithFormat:@"%.1f", [self normalizedDoubleFromDouble:information]];
            break;
        case InformationTypeTimeInterval:
            self.numberLabel.text = [self stringForTimeInterval:information];
            break;
    }
    [self.numberLabel sizeToFit];
    [self layoutSubviews];
}

- (double) normalizedDoubleFromDouble:(double)number {
    // Check for NaN.
    if (number != number) {
        return 0.0;
    }
    return fabs(number);
}

-(NSString*)stringForTimeInterval:(NSTimeInterval)timeInterval{
    NSInteger hours = floor(timeInterval /  (60 * 60) );
    
    CGFloat minute_divisor = (NSInteger)timeInterval % (60 * 60);
    NSInteger minutes = floor(minute_divisor / 60);
    
    CGFloat seconds_divisor = (NSInteger)timeInterval % 60;
    NSInteger seconds = ceil(seconds_divisor);
    
    NSString *hoursString = hours > 0 ? [NSString stringWithFormat:@"%li:", (long)hours] : @"";
    
    NSString *intervalString = [NSString stringWithFormat:@"%@%li:%02li", hoursString, (long)minutes, (long)seconds];
    
    return intervalString;
}

@end
