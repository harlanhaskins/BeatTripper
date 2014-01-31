//
//  PlaylistViewController.m
//  BeatWalker
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlaylistTableViewModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "InformationView.h"
#import "MusicView.h"

@interface PlaylistViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) PlaylistTableViewModel *model;

@property (nonatomic) InformationView *songsLabel;
@property (nonatomic) InformationView *timeLabel;

@property (nonatomic) UIView *informationContainer;

@property (nonatomic) MusicView *musicView;

@end

@implementation PlaylistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.model = [PlaylistTableViewModel model];
    
    self.tableView = [self createTableViewWithRefreshControl];
    
    self.model.tableView = self.tableView;
    
    __weak PlaylistViewController *weakSelf = self;
    self.model.refreshTableViewBlock = ^{
        [weakSelf reloadTableView];
    };
    self.model.playbackTimeUpdated = ^(double playbackTime) {
        [weakSelf.timeLabel setInformation:playbackTime];
    };
    self.model.songNumberUpdated = ^(double songNumber) {
        [weakSelf.songsLabel setInformation:songNumber];
    };
    
    self.tableView.backgroundColor =
    self.view.backgroundColor = [UIColor beatWalkerBackgroundColor];
    
    self.tableView.separatorColor = [UIColor beatWalkerSeparatorColor];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = self.model;
    
    [self.view addSubview:self.tableView];
    
    self.musicView = [MusicView new];
    self.musicView.delegate = self.model;
    [self.view addSubview:self.musicView];
    
    self.songsLabel = [InformationView viewWithInformationType:InformationTypeNumber];
    
    self.timeLabel = [InformationView viewWithInformationType:InformationTypeTimeInterval];
    
    self.informationContainer = [UIView new];
    [self.informationContainer addSubview:self.timeLabel];
    [self.informationContainer addSubview:self.songsLabel];
    [self.view addSubview:self.informationContainer];
    
    [self.model loadSongs];
}

- (UITableView*) createTableViewWithRefreshControl {
    UITableViewController *tableVCForRefreshControl = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableVCForRefreshControl.refreshControl = [UIRefreshControl new];
    [tableVCForRefreshControl.refreshControl addTarget:self.model action:@selector(loadSongs) forControlEvents:UIControlEventAllEvents];
    self.refreshControl = tableVCForRefreshControl.refreshControl;
    
    return tableVCForRefreshControl.tableView;
}

- (void) reloadTableView {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewDidLayoutSubviews {
    self.tableView.frame = self.view.frame;
    self.tableView.height /= 2.0;
    [self.tableView centerToParent];
    self.tableView.y += 50.0;
    
    CGRect musicViewRect;
    musicViewRect.origin.y = self.tableView.bottom;
    musicViewRect.size.width = self.view.width;
    musicViewRect.size.height = self.view.height - musicViewRect.origin.y;
    self.musicView.frame = musicViewRect;
    
    CGRect informationViewRect;
    informationViewRect.origin = CGPointZero;
    informationViewRect.size.width = self.view.width;
    informationViewRect.size.height = self.tableView.y;
    self.informationContainer.frame = informationViewRect;
    
    CGFloat infoContainerAdjuster = self.informationContainer.width / 3;
    
    [self.timeLabel centerToParent];
    self.timeLabel.y -= 40.0;
    self.timeLabel.centerX = infoContainerAdjuster;
    
    [self.songsLabel centerToParent];
    self.songsLabel.y -= 40.0;
    self.songsLabel.centerX = infoContainerAdjuster * 2;
}

@end
