//
//  MediaItemTableViewCell.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class MPMediaItem;

@interface MediaItemTableViewCell : SWTableViewCell

@property (nonatomic, readonly) MPMediaItem *mediaItem;
+ (instancetype) cellWithMediaItem:(MPMediaItem*)item containingTableView:(UITableView*)tableView isCurrentSong:(BOOL)currentSong;

@end
