//
//  RouteViewController.m
//  BeatTripper
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "RouteViewController.h"
#import "RouteTableViewModel.h"
#import "RouteManager.h"
#import "NewRouteViewController.h"
#import "RouteCell.h"

@interface RouteViewController ()

@property (nonatomic) NSString *noRoutesAttributedString;

@end

@implementation RouteViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.noRoutesAttributedString = [self noRoutesAttributedString];
    [self reloadTableView];
}

- (void) reloadTableView {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSAttributedString*) newNoRoutesAttributedString {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
                                         initWithString:@"Tap the + icon\nto get started!"];
    
    NSRange plusRange = [string.string rangeOfString:@"+"];
    NSRange beforePlusRange = NSMakeRange(0, plusRange.location);
    NSInteger start = plusRange.location + 1;
    NSRange afterPlusRange = NSMakeRange(start, string.string.length - start);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor beatTripperTextColor] range:beforePlusRange];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor beatTripperGreenColor] range:plusRange];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor beatTripperTextColor] range:afterPlusRange];
    return string;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[RouteManager sharedManager] numberOfRoutes];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Route *route = [[RouteManager sharedManager] routeAtIndex:indexPath.row];
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteCell" forIndexPath:indexPath];
    cell.route = route;
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[RouteManager sharedManager] deleteRouteAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
