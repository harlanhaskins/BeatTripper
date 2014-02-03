//
//  MediaItemTableViewCell.m
//  BeatTripper
//
//  Created by Harlan Haskins on 1/29/14.
//  Copyright (c) 2014 BeatTripper. All rights reserved.
//

#import "MediaItemTableViewCell.h"
#import "MPMediaItem-Properties.h"

@interface MediaItemTableViewCell ()

@property (nonatomic, readwrite) MPMediaItem *mediaItem;

@end

@implementation MediaItemTableViewCell

+ (instancetype) cellWithMediaItem:(MPMediaItem*)item isCurrentSong:(BOOL)currentSong {
    MediaItemTableViewCell *cell = [[MediaItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    cell.mediaItem = item;
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.artist;
    
    cell.textLabel.textColor =
    cell.detailTextLabel.textColor = currentSong ? [UIColor beatTripperTextColor] : [UIColor beatTripperUnhighlightedTextColor];
    
    cell.imageView.image = item.artwork;
    [cell.imageView setClipsToBounds:YES];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.textLabel.width -= 15.0;
    
    cell.accessoryView = [UIView new];
    
    UILabel *timeStampLabel = [item cellTimeStampLabel];
    timeStampLabel.center = CGPointMake(cell.width - 20.0, 44.0 / 2.0);
    
    [cell.contentView addSubview:timeStampLabel];
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
