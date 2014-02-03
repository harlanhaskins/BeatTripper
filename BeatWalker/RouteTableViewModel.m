//
//  RouteTableViewModel.m
//  BeatTripper
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import "RouteTableViewModel.h"
#import "RouteManager.h"
#import "RouteCell.h"

@interface RouteTableViewModel ()

@property (nonatomic) NSArray *routes;

@end

@implementation RouteTableViewModel

+ (instancetype) model
{
    RouteTableViewModel *model = [RouteTableViewModel new];
    return model;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[RouteManager sharedManager] numberOfRoutes];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Route* route = [[RouteManager sharedManager] routeAtIndex:indexPath.row];
    RouteCell *cell = [RouteCell cellWithRoute:route];
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[RouteManager sharedManager] deleteRouteAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.pushRouteAtIndex(indexPath.row);
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = tableView.backgroundColor;
}

@end
