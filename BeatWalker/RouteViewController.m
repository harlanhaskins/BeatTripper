//
//  RouteViewController.m
//  BeatWalker
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "RouteViewController.h"
#import "RouteTableViewModel.h"
#import "RouteManager.h"
#import "NewRouteViewController.h"

@interface RouteViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) RouteTableViewModel *model;
@property (nonatomic) UILabel *pickRouteLabel;

@property (nonatomic) UIButton *addRouteButton;

@end

@implementation RouteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor beatWalkerBackgroundColor];
    
    self.model = [RouteTableViewModel model];
    
    self.pickRouteLabel = [UILabel new];
    self.pickRouteLabel.text = @"Choose your Route";
    self.pickRouteLabel.textColor = [UIColor beatWalkerTextColor];
    self.pickRouteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:26.0];
    [self.pickRouteLabel sizeToFit];
    [self.view addSubview:self.pickRouteLabel];
    
    __weak RouteViewController *weakSelf = self;
    self.model.reloadTableViewCell = ^{
        [weakSelf.tableView reloadData];
    };
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.dataSource = self.model;
    self.tableView.delegate = self.model;
    
    [self.view addSubview:self.tableView];
    
    self.addRouteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addRouteButton setImage:[UIImage imageNamed:@"PlusButton"] forState:UIControlStateNormal];
    [self.addRouteButton addTarget:self action:@selector(showNewRouteViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.addRouteButton sizeToFit];
    self.addRouteButton.size = CGSizeApplyAffineTransform(self.addRouteButton.size, CGAffineTransformMakeScale(0.65, 0.65));
    [self.view addSubview:self.addRouteButton];
    
    if ([RouteManager sharedManager].routes.count == 0) {
        [self showNewRouteViewController];
    }
}

- (void) showNewRouteViewController {
    NewRouteViewController *newRouteVC = [NewRouteViewController new];
    newRouteVC.finishedCreatingRouteBlock = ^(Route* route) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (route) {
            [[RouteManager sharedManager] addRoute:route];
            [self.tableView reloadData];
        }
    };
    [self presentViewController:newRouteVC animated:YES completion:nil];
}

- (void) viewDidLayoutSubviews {
    self.tableView.frame = self.view.frame;
    self.tableView.height *= 0.75;
    self.tableView.bottom = self.view.height;
    
    [self.pickRouteLabel centerToParent];
    self.pickRouteLabel.centerY = (self.tableView.y / 2);
    
    [self.addRouteButton centerToParent];
    self.addRouteButton.right = self.view.right - 15.0;
    self.addRouteButton.centerY = self.pickRouteLabel.centerY;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
