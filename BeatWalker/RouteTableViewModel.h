//
//  RouteTableViewModel.h
//  BeatTripper
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaylistViewController.h"
#import "SWTableViewCell.h"

@interface RouteTableViewModel : NSObject<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

+ (instancetype) model;

@property (nonatomic, copy) void (^reloadTableViewCell)();
@property (nonatomic, copy) void (^pushRouteAtIndex)(NSInteger index);

@end
