//
//  PlaylistTableViewModel.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "MusicView.h"
#import "PlayPauseButton.h"

@class MPMediaItem, Route;

@interface PlaylistTableViewModel : NSObject<UITableViewDataSource, UITableViewDelegate, MusicViewDelegate>

+ (instancetype) model;
- (void) loadSongs;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) void (^refreshTableViewBlock)();

@property (nonatomic, readonly) MPMediaItem *currentSong;

@property (nonatomic) NSTimer *musicCheckTimer;

- (void) popSong;
- (void) unPopSong;

- (void) finish;

@end
