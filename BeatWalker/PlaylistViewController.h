//
//  PlaylistViewController.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <UIKit/UIKit.h>
#import "MusicView.h"
#import "BWDynamicViewController.h"

@class Route;

@interface PlaylistViewController : BWDynamicViewController

+ (instancetype) controllerWithCompletionBlock:(void (^)(NSTimeInterval time, double songAmount))completion;
@property (nonatomic) Route *route;

@end
