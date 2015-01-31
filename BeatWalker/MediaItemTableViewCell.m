//
//  MediaItemTableViewCell.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import "MediaItemTableViewCell.h"
@import MediaPlayer;

@interface MediaItemTableViewCell ()

@property (nonatomic, readwrite) MPMediaItem *mediaItem;

@end

static NSCache *artworkCache;

@implementation MediaItemTableViewCell

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        artworkCache = [NSCache new];
    });
}

- (void)setMediaItem:(MPMediaItem *)item currentSong:(BOOL)currentSong {
    self.mediaItem = item;
    
    self.textLabel.textColor =
    self.detailTextLabel.textColor = currentSong ? [UIColor beatTripperTextColor] : [UIColor beatTripperUnhighlightedTextColor];
    
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.artist;
    
    [self fetchArtwork];
}

- (void)fetchArtwork {
    if ([artworkCache objectForKey:self.mediaItem.assetURL.absoluteString]) {
        self.imageView.image = [artworkCache objectForKey:self.mediaItem.assetURL.absoluteString];
    } else {
        self.imageView.image = [UIImage imageNamed:@"BlankArtwork"];
        [artworkCache setObject:self.imageView.image forKey:self.mediaItem.assetURL.absoluteString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *artwork = [self.mediaItem.artwork imageWithSize:CGSizeMake(44.0, 44.0)];
            [artworkCache setObject:artwork forKey:self.mediaItem.assetURL.absoluteString];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:0 animations:^{
                    self.imageView.image = artwork;
                } completion:nil];
            });
        });
    }
}

@end
