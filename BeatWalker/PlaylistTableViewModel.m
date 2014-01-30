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
@property (nonatomic) MPMusicPlayerController *musicController;

@end

@implementation PlaylistTableViewModel

+ (instancetype) model {
    PlaylistTableViewModel *model = [PlaylistTableViewModel new];
    model.musicController = [MPMusicPlayerController applicationMusicPlayer];
    [model loadSongs];
    return model;
}

- (void) loadSongs {
    MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
    NSMutableArray *songs = [songQuery collections].mutableCopy;
    [self setSongs:songs];
}

- (void) setSongs:(NSMutableArray *)songs {
    NSMutableArray *newSongs = [NSMutableArray array];
    for (NSInteger i = 0; i < 40; i++) {
        NSInteger index = arc4random_uniform((u_int32_t)songs.count);
        MPMediaItem *song = [songs[index] items][0];
        [songs removeObjectAtIndex:index];
        [newSongs addObject:song];
    }
    _songs = newSongs;
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
    [self.songs removeObjectAtIndex:index];
    [cell.containingTableView deleteRowsAtIndexPaths:@[[cell.containingTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationLeft];
}

@end
