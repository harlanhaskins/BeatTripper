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

@property (nonatomic) UITableView *tableView;
@property (nonatomic) RouteTableViewModel *model;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) UILabel *pickRouteLabel;

@property (nonatomic) UIButton *addRouteButton;

@property (nonatomic) UIView *tableViewTopBorderCoverView;

@property (nonatomic) UILabel *noRoutesLabel;

@property (nonatomic) UIView *checkView;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [RouteTableViewModel model];
    
    self.pickRouteLabel = [UILabel new];
    self.pickRouteLabel.text = @"Your Routes";
    self.pickRouteLabel.textColor = [UIColor beatTripperTextColor];
    self.pickRouteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:26.0];
    [self.pickRouteLabel sizeToFit];
    [self.contentView addSubview:self.pickRouteLabel];
    
    __weak RouteViewController *weakSelf = self;
    self.model.pushRouteAtIndex = ^(NSInteger index){
        [weakSelf pushRouteAtIndex:index];
    };
    self.model.didDeleteRoute = ^(NSInteger index) {
        [weakSelf showNoItemsMessageIfNecessary];
    };
    
    self.tableView = [self createTableViewWithRefreshControl];
    self.tableView.backgroundColor = self.contentView.backgroundColor;
    self.tableView.dataSource = self.model;
    self.tableView.delegate = self.model;
    self.tableView.separatorColor = [UIColor beatTripperSubtleTextColor];
    
    self.tableViewTopBorderCoverView = [UIView new];
    
    [self.contentView addSubview:self.tableViewTopBorderCoverView];
    
    [self.contentView addSubview:self.tableView];
    
    self.addRouteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addRouteButton setImage:[UIImage imageNamed:@"PlusButton"] forState:UIControlStateNormal];
    [self.addRouteButton addTarget:self action:@selector(showNewRouteViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.addRouteButton sizeToFit];
    self.addRouteButton.size = CGSizeApplyAffineTransform(self.addRouteButton.size, CGAffineTransformMakeScale(0.9, 0.9));
    [self.contentView addSubview:self.addRouteButton];
    
    self.noRoutesLabel = [UILabel new];
    self.noRoutesLabel.numberOfLines = 0;
    self.noRoutesLabel.attributedText = [self noRoutesAttributedString];
    self.noRoutesLabel.font = self.pickRouteLabel.font;
    self.noRoutesLabel.textAlignment = NSTextAlignmentCenter;
    [self.noRoutesLabel sizeToFit];
    [self.contentView addSubview:self.noRoutesLabel];
    
    self.checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check"]];
    self.checkView.alpha = 0.0;
    [self.contentView addSubview:self.checkView];
}

- (void) reloadTableView {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [self showNoItemsMessageIfNecessary];
}

- (UITableView*) createTableViewWithRefreshControl {
    UITableViewController *tableVCForRefreshControl = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableVCForRefreshControl.refreshControl = [UIRefreshControl new];
    [tableVCForRefreshControl.refreshControl addTarget:self action:@selector(reloadTableView) forControlEvents:UIControlEventAllEvents];
    self.refreshControl = tableVCForRefreshControl.refreshControl;
    
    return tableVCForRefreshControl.tableView;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSAttributedString*) noRoutesAttributedString {
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

- (void) pushRouteAtIndex:(NSInteger)index {
    Route *route = [[RouteManager sharedManager] routeAtIndex:index];
    void (^updatedRouteBlock)(NSTimeInterval, double) = ^(NSTimeInterval time, double songAmount) {
        [[RouteManager sharedManager] addTime:time toRoute:route];
        [[RouteManager sharedManager] addSongAmount:songAmount toRoute:route];
        [self.tableView reloadData];
        [self performSelector:@selector(flashCheck) withObject:nil afterDelay:0.2];
    };
    PlaylistViewController *playlistVC = [PlaylistViewController controllerWithCompletionBlock:updatedRouteBlock];
    [self presentViewController:playlistVC animated:NO completion:nil];
}

- (void) flashCheck {
    [UIView animateWithDuration:0.0 animations:^{
        self.checkView.alpha = 0.75;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.checkView.alpha = 0.0;
        }];
    }];
}

- (void) showNewRouteViewController {
    NewRouteViewController *newRouteVC = [NewRouteViewController new];
    newRouteVC.finishedCreatingRouteBlock = ^(Route* route) {
        if (route) {
            [[RouteManager sharedManager] addRoute:route];
            [self.tableView reloadData];
        }
        [self showNoItemsMessageIfNecessary];
    };
    [self presentViewController:newRouteVC animated:NO completion:nil];
}

- (void) showNoItemsMessageIfNecessary {
    self.noRoutesLabel.hidden = ![self shouldShowNoItemsLabel];
}

- (BOOL) shouldShowNoItemsLabel {
    return [[RouteManager sharedManager] numberOfRoutes] == 0;
}

- (void) viewDidLayoutSubviews {
    self.tableView.frame = self.view.frame;
    self.tableView.height *= 0.75;
    self.tableView.bottom = self.contentView.height;
    
    [self.checkView centerToParent];
    
    CGFloat sidePadding = 25.0;
    
    [self.pickRouteLabel centerToParent];
    self.pickRouteLabel.x = sidePadding;
    self.pickRouteLabel.centerY = (self.tableView.y / 2);
    
    [self.addRouteButton centerToParent];
    self.addRouteButton.right = self.contentView.right - sidePadding;
    self.addRouteButton.centerY = self.pickRouteLabel.centerY;
    
    [self setTableViewBorderCovers];
    
    [self.noRoutesLabel centerToParent];
    
    [self showNoItemsMessageIfNecessary];
}


- (void) setTableViewBorderCovers {
    self.tableViewTopBorderCoverView.backgroundColor = [UIColor beatTripperSubtleTextColor];
    
    self.tableViewTopBorderCoverView.width = self.contentView.width; // * 1.5;
    
    self.tableViewTopBorderCoverView.height = (1.0 / [[UIScreen mainScreen] scale]);
    
    [self.tableViewTopBorderCoverView centerToParent];
    
    self.tableViewTopBorderCoverView.y = self.tableView.y - (1.0 / [[UIScreen mainScreen] scale]);
}

@end
