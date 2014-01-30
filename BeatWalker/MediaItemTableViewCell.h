//
//  MediaItemTableViewCell.h
//  BeatWalker
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class MPMediaItem;

@interface MediaItemTableViewCell : SWTableViewCell

+ (instancetype) cellWithMediaItem:(MPMediaItem*)item containingTableView:(UITableView*)tableView;

@end
