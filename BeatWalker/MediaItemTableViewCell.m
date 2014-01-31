//
//  MediaItemTableViewCell.m
//  BeatWalker
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import "MediaItemTableViewCell.h"
#import "MPMediaItem-Properties.h"

@interface MediaItemTableViewCell ()

@property (nonatomic) MPMediaItem *item;

@end

@implementation MediaItemTableViewCell

+ (instancetype) cellWithMediaItem:(MPMediaItem*)item {
    MediaItemTableViewCell *cell = [[MediaItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SongCell"];
    
    cell.item = item;
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.artist;
    cell.imageView.image = item.artwork;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
