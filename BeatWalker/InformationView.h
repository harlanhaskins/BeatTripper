//
//  InformationView.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
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
