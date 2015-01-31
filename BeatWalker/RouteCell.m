//
//  RouteCell.m
//  BeatTripper
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "RouteCell.h"
#import "Route.h"

@implementation RouteCell

- (void)setRoute:(Route *)route {
    self.textLabel.text = route.name;
    self.detailTextLabel.text = route.details;
}

@end
