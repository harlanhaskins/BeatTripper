//
//  RouteTableViewModel.m
//  BeatTripper
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
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
    [tableView beginUpdates];
    [[RouteManager sharedManager] deleteRouteAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
    self.didDeleteRoute(indexPath.row);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.pushRouteAtIndex(indexPath.row);
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = tableView.backgroundColor;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *cellCover = [[UIView alloc] initWithFrame:CGRectZero];
    cellCover.backgroundColor = tableView.backgroundColor;
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 1.0 / [UIScreen mainScreen].scale)];
    separator.backgroundColor = tableView.separatorColor;
    [cellCover addSubview:separator];
    return cellCover;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.0;
}

@end
