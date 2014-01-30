//
//  PlaylistTableViewModel.h
//  BeatWalker
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWTableViewCell.h"

@interface PlaylistTableViewModel : NSObject<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

+ (instancetype) model;

@end
