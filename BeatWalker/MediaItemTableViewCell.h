//
//  MediaItemTableViewCell.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <UIKit/UIKit.h>

@class MPMediaItem;

@interface MediaItemTableViewCell : UITableViewCell

- (void)setMediaItem:(MPMediaItem *)item currentSong:(BOOL)currentSong;

@end
