//
//  PlaylistViewController.h
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//  Distributed under the MIT license.
//

#import <UIKit/UIKit.h>
#import "MusicView.h"

@class Route;

@class PlaylistViewController;
@protocol PlaylistViewControllerDelegate <NSObject>

- (void)playlistViewController:(PlaylistViewController *)controller didSaveTripWithElapsedTime:(NSTimeInterval)time numberOfSongs:(CGFloat)songs;

@end

@interface PlaylistViewController : UITableViewController

@property (nonatomic) Route *route;

@end
