//
//  NewRouteView.h
//  BeatTripper
//
//  Created by Harlan Haskins on 2/2/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Route;

@interface NewRouteView : UIView<UITextFieldDelegate>

@property (nonatomic, copy) void (^finishedCreatingRouteBlock)(Route* route);

@end
