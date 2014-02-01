//
//  NewRouteViewController.h
//  BeatWalker
//
//  Created by Harlan Haskins on 2/1/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "BWDynamicViewController.h"

@class Route;

@interface NewRouteViewController : BWDynamicViewController<UITextFieldDelegate>

@property (nonatomic, copy) void (^finishedCreatingRouteBlock)(Route* route);

@end
