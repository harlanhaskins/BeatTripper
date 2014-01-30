//
//  MediaItemTableViewCell.h
//  BeatWalker
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMediaItem;

@interface MediaItemTableViewCell : UITableViewCell

+ (instancetype) cellWithMediaItem:(MPMediaItem*)item;

@end
