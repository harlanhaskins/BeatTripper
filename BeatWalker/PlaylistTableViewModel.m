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
@property (nonatomic) MPMusicPlayerController *musicController;

@end

@implementation PlaylistTableViewModel

+ (instancetype) model {
    PlaylistTableViewModel *model = [PlaylistTableViewModel new];
    model.musicController = [MPMusicPlayerController applicationMusicPlayer];
    return model;
}

- (void) loadSongs {
    if (self.songs) {
        self.songs = nil;
    }
    MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MediaItemTableViewCell *cell = [MediaItemTableViewCell cellWithMediaItem:self.songs[indexPath.row] containingTableView:tableView];
    cell.delegate = self;
    return cell;
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSInteger songIndex = [self.tableView indexPathForCell:cell].row;
    [self removeSongAtIndex:songIndex];
}

- (void) removeSongAtIndex:(NSInteger)songIndex {
    [self.songs removeObjectAtIndex:songIndex];
    
    [self.tableView deleteRowsAtIndexPaths:@[[cell.containingTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationLeft];
    [self performSelector:@selector(fillSongs) withObject:nil afterDelay:0.5];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = tableView.backgroundColor;
}

@end
