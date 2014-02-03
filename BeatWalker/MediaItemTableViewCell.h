//
//  MediaItemTableViewCell.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMediaItem;

@interface MediaItemTableViewCell : UITableViewCell

@property (nonatomic, readonly) MPMediaItem *mediaItem;
+ (instancetype) cellWithMediaItem:(MPMediaItem*)item isCurrentSong:(BOOL)currentSong;

@end
