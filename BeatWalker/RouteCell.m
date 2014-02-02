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

+ (instancetype) cellWithRoute:(Route *)route containingTableView:(UITableView*)tableView
{
    UIColor *deleteColor = [UIColor colorWithRed:239.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:1.0];
    NSMutableArray *utilityButtons = [NSMutableArray array];
    [utilityButtons sw_addUtilityButtonWithColor:deleteColor title:@"Delete"];
    
    RouteCell *cell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:@"RouteCell"
                                   containingTableView:tableView
                                    leftUtilityButtons:nil
                                   rightUtilityButtons:utilityButtons];
    
    cell.route = route;
    cell.textLabel.text = route.name;
    cell.textLabel.textColor = [UIColor beatWalkerTextColor];
    cell.contentView.backgroundColor =
    cell.backgroundColor = cell.containingTableView.backgroundColor;
    cell.detailTextLabel.text = route.details;
    cell.detailTextLabel.textColor = [UIColor beatWalkerTextColor];
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
