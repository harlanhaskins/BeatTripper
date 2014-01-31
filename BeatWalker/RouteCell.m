//
//  RouteCell.m
//  BeatWalker
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "RouteCell.h"
#import "Route.h"

@interface RouteCell ()

@property (nonatomic) Route *route;

@end

@implementation RouteCell

+ (instancetype) cellWithRoute:(Route *)route
{
    RouteCell *cell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RouteCell"];
    
    cell.route = route;
    cell.textLabel.text = route.name;
    cell.detailTextLabel.text = route.details;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
