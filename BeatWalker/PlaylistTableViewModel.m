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
#import "NSMutableArray+Shuffle.h"

@interface PlaylistTableViewModel ()

@property (nonatomic) NSMutableArray *songs;
@property (nonatomic) NSMutableArray *collections;
@property (nonatomic) NSMutableArray *poppedSongStack;
@property (nonatomic) MPMusicPlayerController *musicController;

@property (nonatomic) MPMediaItemCollection *collection;

@property (nonatomic) NSUInteger currentPlayingSongIndex;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:model
                                             selector:@selector(handleNowPlayingItemChange)
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:model.musicController];
    
    [model.musicController beginGeneratingPlaybackNotifications];
    model.musicController.shuffleMode = MPMusicShuffleModeOff;
    
    [[NSRunLoop currentRunLoop] addTimer:model.musicCheckTimer forMode:NSDefaultRunLoopMode];
    return model;
}

- (void) loadSongs {
    if (self.songs) {
        self.songs = nil;
    }
    MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
    
    MPMediaItemCollection *collection = [self shuffledCollectionWithMediaQuery:songQuery];
    self.collection = collection;
    [self.musicController setQueueWithItemCollection:collection];
    
    [self fillSongs];
}

- (MPMediaItemCollection*) shuffledCollectionWithMediaQuery:(MPMediaQuery*)query {
    NSMutableArray *collectionsArray = [query collections].mutableCopy;
    [collectionsArray shuffle];
    
    NSMutableArray *songsArray = [NSMutableArray array];
    for (MPMediaItemCollection *collection in collectionsArray) {
        MPMediaItem *song = [collection items][0];
        [songsArray addObject:song];
    }
    
    MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:songsArray];
    return collection;
}

- (void) fillSongs {
    if (!self.songs) {
        self.songs = [NSMutableArray array];
    }
    
    if (!self.poppedSongStack) {
        self.poppedSongStack = [NSMutableArray array];
    }
    
    const NSUInteger queueSize = 40;
    
    
    NSUInteger index = self.currentPlayingSongIndex;
    while (self.songs.count < queueSize && index < self.collection.items.count) {
        MPMediaItem *song = [self.collection items][index];
        [self.songs addObject:song];
        index++;
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
    [self.musicController setNowPlayingItem:self.songs[indexPath.row]];
    [self resetCurrentItem];
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        [self advanceToNextSong];
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
    NSLog(@"Popping. Current Index: %li", self.currentPlayingSongIndex);
    [self removeSongAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.currentPlayingSongIndex++;
    [self resetCurrentItem];
}

- (void) removeSongAtIndexPath:(NSIndexPath*)indexPath {
    MPMediaItem *song = self.songs[indexPath.row];
    [self.songs removeObjectAtIndex:indexPath.row];
    
    [self.poppedSongStack insertObject:song atIndex:0];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self performSelector:@selector(fillSongs) withObject:nil afterDelay:0.75];
}

- (void) unPopSong {
    if (self.poppedSongStack.count == 0) return;
    
    NSLog(@"UnPopping. Current Index: %li", self.currentPlayingSongIndex);
    
    MPMediaItem *song = self.poppedSongStack[0];
    [self.poppedSongStack removeObjectAtIndex:0];
    [self.songs insertObject:song atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.75];
    
    [self resetCurrentItem];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = tableView.backgroundColor;
}

- (void) advanceToNextSong {
    [self adjustInternalMusicRepresentationForNextSong];
    [self.musicController setNowPlayingItem:self.currentSong];
}

- (void) adjustInternalMusicRepresentationForNextSong {
    self.totalSongsPlayed += self.currentSongPlayTime;
    self.totalSongAmount += self.currentSongAmount;
    [self popSong];
}

- (void) returnToPreviousSong {
    [self unPopSong];
    [self.musicController setNowPlayingItem:self.currentSong];
}

- (void) resetCurrentItem {
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

- (void) adjustCurrentSongToIndex:(NSUInteger)index {
    if (self.currentPlayingSongIndex > index) {
        while (self.poppedSongStack.count < index) {
            [self performSelector:@selector(adjustInternalMusicRepresentationForNextSong) withObject:nil afterDelay:0.1];
        }
    }
    else {
        while (self.poppedSongStack.count > index) {
            [self performSelector:@selector(unPopSong) withObject:nil afterDelay:0.1];
        }
    }
    self.currentPlayingSongIndex = index;
}

- (void) handleNowPlayingItemChange {
    NSUInteger musicControllerSongIndex = [self.musicController indexOfNowPlayingItem];
    if (musicControllerSongIndex != NSNotFound) {
        [self adjustCurrentSongToIndex:musicControllerSongIndex];
    }
}

@end
