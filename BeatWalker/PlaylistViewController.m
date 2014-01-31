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
#import "MusicView.h"

@interface PlaylistViewController ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) PlaylistTableViewModel *model;
@property (nonatomic) MPMusicPlayerController *musicController;

@property (nonatomic) MusicView *musicView;

@end

@implementation PlaylistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.model = [PlaylistTableViewModel model];
    
    self.tableView = [self createTableViewWithRefreshControl];
    
    self.musicController = [MPMusicPlayerController iPodMusicPlayer];
    
    self.model.tableView = self.tableView;
    
    __weak PlaylistViewController *weakSelf = self;
    self.model.refreshTableViewBlock = ^{
        [weakSelf reloadTableView];
    };
    
    self.tableView.backgroundColor =
    self.view.backgroundColor = [UIColor beatWalkerBackgroundColor];
    
    self.tableView.separatorColor = [UIColor beatWalkerSeparatorColor];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = self.model;
    
    [self.view addSubview:self.tableView];
    
    self.musicView = [MusicView new];
    self.musicView.delegate = self;
    [self.view addSubview:self.musicView];
    
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
    
    CGRect musicViewRect;
    musicViewRect.origin.y = self.tableView.bottom;
    musicViewRect.size.width = self.view.width;
    musicViewRect.size.height = self.view.height - musicViewRect.origin.y;
    self.musicView.frame = musicViewRect;
}

- (void) advanceToNextSong {
    [self.model popSong];
    [self resetCurrentItem];
}

- (void) returnToPreviousSong {
    [self.model unPopSong];
    [self resetCurrentItem];
}

- (void) resetCurrentItem {
    MPMediaItem *song = [self.model currentSong];
    NSLog(@"Song: %@", song);
    [self.musicController setNowPlayingItem:song];
}

- (void) togglePlayback:(PlayState)state {
    if (![self.musicController nowPlayingItem]) {
        [self resetCurrentItem];
    }
    if (state == PlayStatePaused) {
        [self.musicController stop];
    }
    else if (state == PlayStatePlaying) {
        NSLog(@"Song: %@", [self.musicController nowPlayingItem]);
        [self.musicController play];
    }
}

@end
