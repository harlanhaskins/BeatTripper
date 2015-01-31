//
//  NewRouteViewController.h
//  BeatTripper
//
//  Created by Harlan Haskins on 2/1/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

@import UIKit;

@class Route;

@interface NewRouteViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, copy) void (^finishedCreatingRouteBlock)(Route* route);

@end
