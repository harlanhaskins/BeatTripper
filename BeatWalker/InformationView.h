//
//  InformationView.h
//  BeatWalker
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    InformationTypeTimeInterval,
    InformationTypeNumber
} InformationType;

@interface InformationView : UIView

+ (instancetype) viewWithInformationType:(InformationType)type;

- (void) setType:(NSString*)type;

- (void) setInformation:(double)information;

@end
