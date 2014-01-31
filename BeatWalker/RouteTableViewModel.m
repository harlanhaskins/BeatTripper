//
//  RouteTableViewModel.m
//  BeatWalker
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "RouteTableViewModel.h"
#import "RouteCell.h"

@interface RouteTableViewModel ()

@property (nonatomic) NSArray *routes;

@end

@implementation RouteTableViewModel

+ (instancetype) model
{
    RouteTableViewModel *model = [RouteTableViewModel new];
    [model loadRoutes];
    return model;
}

- (void) loadRoutes
{
}

- (void) setRoutes:(NSMutableArray *)routes
{
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.routes.count;
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [RouteCell cellWithRoute:self.routes[indexPath.row]];
    return cell;
}

@end
