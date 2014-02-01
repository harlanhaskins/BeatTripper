//
//  PlaylistTableViewModel.h
//  BeatWalker
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWTableViewCell.h"
#import "MusicView.h"
#import "PlayPauseButton.h"

@class MPMediaItem, Route;

@interface PlaylistTableViewModel : NSObject<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, MusicViewDelegate>

+ (instancetype) model;
- (void) loadSongs;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) Route *route;

@property (nonatomic, copy) void (^refreshTableViewBlock)();

@property (nonatomic, copy) void (^playbackTimeUpdated)(double playbackTime);
@property (nonatomic, copy) void (^songNumberUpdated)(double songNumber);

@property (nonatomic, readonly) MPMediaItem *currentSong;

- (void) popSong;
- (void) unPopSong;

- (void) finish;

@end
