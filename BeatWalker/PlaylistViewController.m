//
//  PlaylistViewController.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "PlaylistViewController.h"
#import "PlaylistTableViewModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "InformationView.h"
#import "MusicView.h"
#import "RouteManager.h"
#import "Route.h"

@interface PlaylistViewController ()

@property (nonatomic) MusicView *musicView;
@property (nonatomic) PlaylistTableViewModel *model;

@end

@implementation PlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [PlaylistTableViewModel new];
    self.tableView.dataSource = self.model;
    self.tableView.delegate = self.model;
    self.model.tableView = self.tableView;
    [self.model loadSongs];
}

- (void) dismiss {
    if (!TARGET_IPHONE_SIMULATOR) {
        [[MPMusicPlayerController systemMusicPlayer] stop];
        [[MPMusicPlayerController systemMusicPlayer] setQueueWithItemCollection:nil];
        [[MPMusicPlayerController systemMusicPlayer] endGeneratingPlaybackNotifications];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.model
                                                        name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                      object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) finish {
    [self.model finish];
    [self dismiss];
}

- (void) reloadTableView {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
