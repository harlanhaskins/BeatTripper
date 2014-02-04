//
//  RouteTableViewModel.h
//  BeatTripper
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "PlaylistViewController.h"

@interface RouteTableViewModel : NSObject<UITableViewDataSource, UITableViewDelegate>

+ (instancetype) model;
@property (nonatomic, copy) void (^pushRouteAtIndex)(NSInteger index);
@property (nonatomic, copy) void (^didDeleteRoute)(NSInteger index);

@end
