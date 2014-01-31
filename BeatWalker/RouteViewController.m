//
//  RouteViewController.m
//  BeatWalker
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "RouteViewController.h"
#import "RouteTableViewModel.h"

@interface RouteViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) RouteTableViewModel *model;

@end

@implementation RouteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [RouteTableViewModel model];
    
    __weak RouteViewController *weakSelf = self;
    self.model.reloadTableViewCell = ^{
        [weakSelf.tableView reloadData];
    };
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = self.model;
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
