//
//  NewRouteViewController.h
//  BeatTripper
//
//  Created by Harlan Haskins on 2/1/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "BWDynamicViewController.h"

@class Route;

@interface NewRouteViewController : BWDynamicViewController<UITextFieldDelegate>

@property (nonatomic, copy) void (^finishedCreatingRouteBlock)(Route* route);

@end
