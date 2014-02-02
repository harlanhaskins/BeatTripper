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
#import "BWDynamicViewController.h"
#import "RouteManager.h"
#import "Route.h"

@interface PlaylistViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) PlaylistTableViewModel *model;

@property (nonatomic) InformationView *songsLabel;
@property (nonatomic) InformationView *timeLabel;

@property (nonatomic) UIView *informationContainer;

@property (nonatomic) MusicView *musicView;

@property (nonatomic) UIView *tableViewTopBorderCoverView;
@property (nonatomic) UIView *tableViewBottomBorderCoverView;
@property (nonatomic) UIButton *finishButton;
@property (nonatomic) UIButton *cancelButton;

@end

@implementation PlaylistViewController

- (void) initializeModel {
    [self.model loadSongs];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];//[self createTableViewWithRefreshControl];
    
    self.model = [PlaylistTableViewModel model];
    
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
    
    [self.model loadSongs];
    
    self.model.tableView = self.tableView;
    
    self.tableView.backgroundColor = [UIColor beatWalkerBackgroundColor];
    
    self.tableView.separatorColor = [UIColor beatWalkerSeparatorColor];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = self.model;
    
    [self.contentView addSubview:self.tableView];
    
    self.musicView = [MusicView new];
    self.musicView.delegate = self.model;
    [self.contentView addSubview:self.musicView];
    
    self.songsLabel = [InformationView viewWithInformationType:InformationTypeNumber];
    
    self.timeLabel = [InformationView viewWithInformationType:InformationTypeTimeInterval];
    
    self.informationContainer = [UIView new];
    [self.informationContainer addSubview:self.timeLabel];
    [self.informationContainer addSubview:self.songsLabel];
    [self.contentView addSubview:self.informationContainer];
    
    self.tableViewTopBorderCoverView = [UIView new];
    self.tableViewBottomBorderCoverView = [UIView new];
    
    [self.contentView addSubview:self.tableViewTopBorderCoverView];
    [self.contentView addSubview:self.tableViewBottomBorderCoverView];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setImage:[UIImage imageNamed:@"CheckButton"] forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton sizeToFit];
    [self.contentView addSubview:self.finishButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"XButton"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    [self.contentView addSubview:self.cancelButton];
}

- (void) dismiss {
    [self addOuterSnapBehavior];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[MPMusicPlayerController applicationMusicPlayer] stop];
}

- (void) finish {
    [self.model finish];
    [self dismiss];
}

- (UITableView*) createTableViewWithRefreshControl {
    UITableViewController *tableVCForRefreshControl = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableVCForRefreshControl.refreshControl = [UIRefreshControl new];
    [tableVCForRefreshControl.refreshControl addTarget:self.model action:@selector(loadSongs) forControlEvents:UIControlEventAllEvents];
    self.refreshControl = tableVCForRefreshControl.refreshControl;
    
    return tableVCForRefreshControl.tableView;
}

- (void) setRoute:(Route *)route {
    _route = route;
    self.model.route = route;
}

- (void) reloadTableView {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void) viewDidLayoutSubviews {
    self.tableView.frame = self.contentView.frame;
    self.tableView.height /= 1.5;
    self.tableView.width += 1;
    [self.tableView centerToParent];
    self.tableView.y += 25.0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGRect musicViewRect;
    musicViewRect.origin.x = 0;
    musicViewRect.origin.y = self.tableView.bottom;
    musicViewRect.size.width = self.contentView.width;
    musicViewRect.size.height = self.contentView.height - musicViewRect.origin.y;
    self.musicView.frame = musicViewRect;
    
    CGRect informationViewRect;
    informationViewRect.origin = CGPointMake(5.0, 0);
    informationViewRect.size.width = self.contentView.width;
    informationViewRect.size.height = self.tableView.y - self.informationContainer.y;
    self.informationContainer.frame = informationViewRect;
    
    CGFloat infoContainerAdjuster = self.informationContainer.width / 3;
    
    [self.timeLabel centerToParent];
    self.timeLabel.y -= 35.0;
    self.timeLabel.centerX = infoContainerAdjuster;
    
    [self.songsLabel centerToParent];
    self.songsLabel.y -= 35.0;
    self.songsLabel.centerX = infoContainerAdjuster * 2;
    
    CGSize buttonSize = self.finishButton.imageView.image.size;
    buttonSize = CGSizeApplyAffineTransform(buttonSize, CGAffineTransformMakeScale(0.85, 0.85));
    
    self.finishButton.size =
    self.cancelButton.size = buttonSize;
    
    CGFloat buttonSidePadding = 15.0;
    self.finishButton.centerY =
    self.cancelButton.centerY =
    self.informationContainer.centerY + 5.0;
    
    self.finishButton.right = self.contentView.width - buttonSidePadding;
    self.cancelButton.x = buttonSidePadding;
    
    [self setTableViewBorderCovers];
}

- (void) setTableViewBorderCovers {
    self.tableViewTopBorderCoverView.backgroundColor =
    self.tableViewBottomBorderCoverView.backgroundColor = [UIColor beatWalkerSubtleTextColor];
    
    self.tableViewTopBorderCoverView.width =
    self.tableViewBottomBorderCoverView.width = self.contentView.width; // * 1.05;
    
    self.tableViewTopBorderCoverView.height =
    self.tableViewBottomBorderCoverView.height = 0.5;
    
    [self.tableViewTopBorderCoverView centerToParent];
    [self.tableViewBottomBorderCoverView centerToParent];
    
    self.tableViewTopBorderCoverView.y = self.tableView.y - 0.5;
    self.tableViewBottomBorderCoverView.y = self.tableView.bottom;
}

@end
