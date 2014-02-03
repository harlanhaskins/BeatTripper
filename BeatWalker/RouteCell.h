//
//  RouteCell.h
//  BeatTripper
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Route;

@interface RouteCell : UITableViewCell

+ (instancetype) cellWithRoute:(Route *)route;

@end
