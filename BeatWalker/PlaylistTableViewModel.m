//
//  PlaylistTableViewModel.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "PlaylistTableViewModel.h"
#import "MPMediaItem-Properties.h"
#import "MediaItemTableViewCell.h"
#import "NSMutableArray+Shuffle.h"
#import "RouteManager.h"

@interface PlaylistTableViewModel ()

@property (nonatomic) NSMutableArray *deletedIndices;
@property (nonatomic) NSMutableArray *currentIndices;
@property (nonatomic) MPMusicPlayerController *musicController;

@property (nonatomic) MPMediaItemCollection *collection;

@property (nonatomic) NSUInteger currentPlayingSongIndex;

@property (nonatomic) double totalSongPlayTime;
@property (nonatomic) double currentSongPlayTime;

@property (nonatomic) double totalSongAmount;
@property (nonatomic) double currentSongAmount;

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
                                               object:nil];
    
    [model.musicController beginGeneratingPlaybackNotifications];
    
    model.musicController.shuffleMode = MPMusicShuffleModeOff;
    
    [[NSRunLoop currentRunLoop] addTimer:model.musicCheckTimer forMode:NSDefaultRunLoopMode];
    
    return model;
}

- (void) loadSongs {
    // Load songs in the background.
    dispatch_queue_t queue = dispatch_queue_create("SongLoading", NULL);
    dispatch_async(queue, ^{
        
        self.deletedIndices = [NSMutableArray array];
        
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        
        MPMediaItemCollection *collection = [self shuffledCollectionWithMediaQuery:songQuery];
        self.collection = collection;
        [self.musicController setQueueWithItemCollection:collection];
        
        self.currentIndices = [NSMutableArray array];
        NSInteger songLimit = MIN(collection.items.count, 25);
        for (int i = 0; i < songLimit; ++i) {
            [self.currentIndices addObject:@(i)];
        }
//        [self togglePlayback:PlayStatePlaying];
    });
}

- (MPMediaItemCollection*) shuffledCollectionWithMediaQuery:(MPMediaQuery*)query {
    NSArray *querySongsArray = [query items];
    
    NSMutableArray *songsArray = [NSMutableArray array];
    
    NSInteger numberOfCollections = [query items].count;
    NSInteger highestNumberOfItems = 20;
    NSInteger numberOfItems = numberOfCollections >= highestNumberOfItems ? highestNumberOfItems : numberOfCollections;
    for (int i = 0; i < numberOfItems; i++) {
        MPMediaItem *song;
        do {
            NSInteger randomIndex = arc4random_uniform((u_int32_t)[querySongsArray count]);
            song = querySongsArray[randomIndex];
        }
        while ([songsArray indexOfObject:song] != NSNotFound);
        [songsArray addObject:song];
    }
    
    MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:songsArray];
    return collection;
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
    return self.collection.items[self.currentPlayingSongIndex];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentIndices.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger songIndex = [self.currentIndices[indexPath.row] integerValue];
    NSArray *songs = [self.collection items];
    MPMediaItem *song = songs[songIndex];
    
    MediaItemTableViewCell *cell = [MediaItemTableViewCell cellWithMediaItem:song
                                                               isCurrentSong:(indexPath.row == 0)];
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *index = self.currentIndices[indexPath.row];
    [self playSongAtIndex:[index integerValue]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (double) totalTimeWithCurrentTime {
    return self.currentSongPlayTime + self.totalSongPlayTime;
}

- (double) totalSongAmountWithCurrentSongAmount {
    return self.currentSongAmount + self.totalSongAmount;
}

- (void) popSong {
    [self removeSongAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self adjustInternalMusicRepresentationForNextSong];
}

- (void) removeSongAtIndexPath:(NSIndexPath*)indexPath {
    [self.tableView beginUpdates];
    [self.currentIndices removeObjectAtIndex:indexPath.row];
    NSUInteger lastIndex = [self.currentIndices.lastObject integerValue];
    NSUInteger indexToAdd = [self nextPlayableIndexAfterIndex:lastIndex];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSIndexPath *indexPathOfSecondRow = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathOfSecondRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (indexToAdd != NSNotFound) {
        [self.currentIndices addObject:@(indexToAdd)];
        NSIndexPath *indexPathOfLastRow = [NSIndexPath indexPathForRow:(self.currentIndices.count - 1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPathOfLastRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
}

- (void) unPopSong {
    NSUInteger indexToAdd = [self previousPlayableIndexInCollection];
    if (indexToAdd != NSNotFound) {
        NSNumber *indexToAddNumber = @(indexToAdd);
        if ([self.currentIndices indexOfObject:indexToAddNumber] == NSNotFound) {
            [self.tableView beginUpdates];
            
            [self.currentIndices insertObject:indexToAddNumber atIndex:0];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            NSIndexPath *indexPathOfSecondRow = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPathOfSecondRow] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            NSIndexPath *indexPathOfLastRow = [NSIndexPath indexPathForRow:(self.currentIndices.count - 2) inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPathOfLastRow] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.currentIndices removeLastObject];
            
            [self.tableView endUpdates];
            
            [self adjustInternalMusicRepresentationForNextSong];
        }
    }
}

- (NSUInteger) nextPlayableIndexAfterIndex:(NSUInteger)index {
    if (index >= self.collection.items.count) {
        return NSNotFound;
    }
    NSNumber *number = @(index + 1);
    while ([self.deletedIndices indexOfObject:number] != NSNotFound) {
        number = @([number intValue] + 1);
        if ([number integerValue] >= self.collection.items.count) {
            return NSNotFound;
        }
    }
    return [number unsignedIntegerValue];
}

- (NSUInteger) nextPlayableIndexInCollection {
    return [self nextPlayableIndexAfterIndex:self.currentPlayingSongIndex];
}

- (NSUInteger) previousPlayableIndexBeforeIndex:(NSUInteger)index {
    if (index == 0) {
        return NSNotFound;
    }
    NSNumber *number = @(index - 1);
    while ([self.deletedIndices indexOfObject:number] != NSNotFound) {
        number = @([number intValue] - 1);
        if ([number integerValue] < 0) {
            return NSNotFound;
        }
    }
    return [number unsignedIntegerValue];
}

- (NSUInteger) previousPlayableIndexInCollection {
    return [self previousPlayableIndexBeforeIndex:self.currentPlayingSongIndex];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = tableView.backgroundColor;
}

- (void) advanceToNextSong {
    NSUInteger index = [self nextPlayableIndexInCollection];
    if (index != NSNotFound) {
        [self playSongAtIndex:index];
    }
}

- (void) returnToPreviousSong {
    NSUInteger index = [self previousPlayableIndexInCollection];
    if (index != NSNotFound) {
        [self playSongAtIndex:index];
        [self unPopSong];
    }
}

- (void) playSongAtIndex:(NSInteger)index {
    MPMediaItem *song = self.collection.items[index];
    [self.musicController setNowPlayingItem:song];
    [self adjustInternalMusicRepresentationForNextSong];
}

- (void) setCurrentPlayingSongIndex:(NSUInteger)currentPlayingSongIndex {
    _currentPlayingSongIndex = currentPlayingSongIndex;
    [self adjustInternalMusicRepresentationForNextSong];
    NSInteger index = [self.currentIndices indexOfObject:@(self.currentPlayingSongIndex)];
    while (index > 0 && index != NSNotFound) {
        [self popSong];
        --index;
    }
}

- (void) adjustInternalMusicRepresentationForNextSong {
    self.totalSongPlayTime += self.currentSongPlayTime;
    self.totalSongAmount += self.currentSongAmount;
    [self resetCurrentItem];
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

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger songIndex = [self.currentIndices[indexPath.row] integerValue];
    [self.deletedIndices addObject:@(songIndex)];
    if (songIndex == self.musicController.indexOfNowPlayingItem) {
        [self advanceToNextSong];
    }
    else {
        [self removeSongAtIndexPath:indexPath];
    }
}

- (void) handleNowPlayingItemChange {
    NSUInteger musicControllerSongIndex = [self.musicController indexOfNowPlayingItem];
    if (musicControllerSongIndex != NSNotFound) {
        self.currentPlayingSongIndex = musicControllerSongIndex;
        NSLog(@"Current Index: %li", (long)self.currentPlayingSongIndex);
    }
}

- (void) reloadTable {
    self.refreshTableViewBlock();
}

- (void) finish {
    [self adjustInternalMusicRepresentationForNextSong];
    [self.musicCheckTimer invalidate];
    self.updatedRouteBlock(self.totalSongPlayTime, self.totalSongAmount);
}

@end
