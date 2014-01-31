//
//  PlaylistTableViewModel.m
//  BeatWalker
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "PlaylistTableViewModel.h"
#import "MPMediaItem-Properties.h"
#import "MediaItemTableViewCell.h"

@interface PlaylistTableViewModel ()

@property (nonatomic) NSMutableArray *songs;
@property (nonatomic) NSMutableArray *collections;
@property (nonatomic) NSMutableArray *poppedSongStack;
@property (nonatomic) MPMusicPlayerController *musicController;

@property (nonatomic) double totalSongsPlayed;
@property (nonatomic) double currentSongPlayTime;

@property (nonatomic) double totalSongAmount;
@property (nonatomic) double currentSongAmount;

@property (nonatomic) NSTimer *musicCheckTimer;

@end

@implementation PlaylistTableViewModel

+ (instancetype) model {
    PlaylistTableViewModel *model = [PlaylistTableViewModel new];
    model.musicController = [MPMusicPlayerController iPodMusicPlayer];
    model.musicCheckTimer = [NSTimer timerWithTimeInterval:1.0
                                                    target:model
                                                  selector:@selector(updatePlayedSongsCount)
                                                  userInfo:nil
                                                   repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:model.musicCheckTimer forMode:NSDefaultRunLoopMode];
    return model;
}

- (void) loadSongs {
    if (self.songs) {
        self.songs = nil;
    }
    MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
    [self.musicController setQueueWithQuery:songQuery];
    self.collections = [songQuery collections].mutableCopy;
    [self fillSongs];
}

- (void) fillSongs {
    if (!self.songs) {
        self.songs = [NSMutableArray array];
    }
    
    const NSUInteger queueSize = 40;
    
    NSUInteger songs = self.songs.count;
    NSUInteger collections = self.collections.count;
    
    while (songs < queueSize && collections > 0) {
        NSUInteger randomIndex = arc4random_uniform((u_int32_t)collections);
        MPMediaItem *song = [self.collections[randomIndex] items][0];
        [self.collections removeObjectAtIndex:randomIndex];
        [self.songs addObject:song];
        
        songs = self.songs.count;
        collections = self.collections.count;
    }
    self.refreshTableViewBlock();
}

- (void) updatePlayedSongsCount {
    MPMusicPlaybackState state = [self.musicController playbackState];
    if (state == MPMusicPlaybackStatePlaying) {
        double currentTime = self.musicController.currentPlaybackTime;
        double totalTime = self.musicController.nowPlayingItem.playbackDuration;
        self.currentSongPlayTime = currentTime;
        self.currentSongAmount = currentTime / totalTime;
        self.playbackTimeUpdated([self totalTimeWithCurrentTime]);
        self.songNumberUpdated([self totalSongAmountWithCurrentSongAmount]);
    }
}

- (MPMediaItem*) currentSong {
    return self.songs[0];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MediaItemTableViewCell *cell = [MediaItemTableViewCell cellWithMediaItem:self.songs[indexPath.row] containingTableView:tableView];
    cell.delegate = self;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSInteger i = 0; i < indexPath.row; i++) {
        [self popSong];
    }
    [self resetCurrentItem];
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        [self popSong];
    }
    else {
        [self removeSongAtIndexPath:indexPath];
    }
}

- (double) totalTimeWithCurrentTime {
    return self.currentSongPlayTime + self.totalSongsPlayed;
}

- (double) totalSongAmountWithCurrentSongAmount {
    return self.currentSongAmount + self.totalSongAmount;
}

- (void) popSong {
    [self removeSongAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void) removeSongAtIndexPath:(NSIndexPath*)indexPath {
    MPMediaItem *song = self.songs[indexPath.row];
    [self.songs removeObjectAtIndex:indexPath.row];
    
    if (!self.poppedSongStack) {
        self.poppedSongStack = [NSMutableArray array];
    }
    
    [self.poppedSongStack insertObject:song atIndex:0];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self performSelector:@selector(fillSongs) withObject:nil afterDelay:0.75];
}

- (void) unPopSong {
    if (self.poppedSongStack.count == 0) return;
    
    MPMediaItem *song = self.poppedSongStack[0];
    [self.poppedSongStack removeObjectAtIndex:0];
    [self.songs insertObject:song atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.75];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = tableView.backgroundColor;
}

- (void) advanceToNextSong {
    self.totalSongsPlayed += self.currentSongPlayTime;
    self.totalSongAmount += self.currentSongAmount;
    [self popSong];
    [self resetCurrentItem];
}

- (void) returnToPreviousSong {
    [self unPopSong];
    [self resetCurrentItem];
}

- (void) resetCurrentItem {
    MPMediaItem *song = [self currentSong];
    [self.musicController setNowPlayingItem:song];
    self.currentSongPlayTime = 0.0;
    self.currentSongAmount = 0.0;
}

- (void) togglePlayback:(PlayState)state {
    if (![self.musicController nowPlayingItem]) {
        [self resetCurrentItem];
    }
    if (state == PlayStatePaused) {
        [self.musicController pause];
    }
    else if (state == PlayStatePlaying) {
        [self.musicController play];
    }
}

@end
