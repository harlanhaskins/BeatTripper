//
//  PlaylistTableViewModel.m
//  BeatWalker
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "PlaylistTableViewModel.h"

@interface PlaylistTableViewModel ()

@property (nonatomic) NSArray *songs;

@end

@implementation PlaylistTableViewModel

+ (instancetype) modelWithSongs:(NSArray*)songs {
    PlaylistTableViewModel *model = [PlaylistTableViewModel new];
    model.songs = songs;
    return model;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SongCell"];
    return cell;
}

@end
