//
//  RouteCell.h
//  BeatTripper
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class Route;

@interface RouteCell : SWTableViewCell

+ (instancetype) cellWithRoute:(Route *)route containingTableView:(UITableView*)tableView;

@end
