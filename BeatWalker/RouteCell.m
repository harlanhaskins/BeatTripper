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

@interface RouteCell ()

@property (nonatomic) Route *route;

@end

@implementation RouteCell

+ (instancetype) cellWithRoute:(Route *)route
{
    RouteCell *cell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:@"RouteCell"];
    
    cell.route = route;
    cell.textLabel.text = route.name;
    cell.detailTextLabel.text = route.details;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = [UIColor beatTripperTextColor];
    cell.contentView.backgroundColor =
    cell.backgroundColor = [UIColor beatTripperBackgroundColor];
    cell.detailTextLabel.textColor = [UIColor beatTripperTextColor];
    
    return cell;
}

@end
