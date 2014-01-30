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

@property (nonatomic) NSArray *songs;
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
    [self.musicController setQueueWithQuery:songQuery];
    self.musicController.shuffleMode = MPMusicShuffleModeSongs;
}

- (NSMutableArray*) allSongsFromCollectionArray:(NSArray*)collections {
    NSMutableArray *songs = [NSMutableArray array];
    for (MPMediaItemCollection *collection in collections) {
        [songs addObjectsFromArray:[collection items]];
    }
    return songs;
}

- (void) setSongs:(NSMutableArray *)songs {
    songs = [self allSongsFromCollectionArray:songs];
    NSMutableArray *newSongs = [NSMutableArray array];
    for (NSInteger i = 0; i < 40; i++) {
        NSInteger index = arc4random_uniform((u_int32_t)songs.count);
        MPMediaItem *song = songs[index];
        [songs removeObjectAtIndex:index];
        [newSongs addObject:song];
    }
    _songs = newSongs;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [MediaItemTableViewCell cellWithMediaItem:self.songs[indexPath.row]];
    return cell;
}

@end
