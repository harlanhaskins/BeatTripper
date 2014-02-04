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
    
    cell.textLabel.textColor =
    cell.detailTextLabel.textColor = YES ? [UIColor beatTripperTextColor] : [UIColor beatTripperUnhighlightedTextColor];
    [cell.imageView setClipsToBounds:YES];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.textLabel.width -= 15.0;
    
    cell.accessoryView = [UIView new];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *artwork = item.artwork;
        NSString *artist = item.artist;
        NSString *title = item.title;
        
        UILabel *timeStampLabel = [item cellTimeStampLabel];
        timeStampLabel.center = CGPointMake(cell.width - 20.0, 44.0 / 2.0);
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            cell.textLabel.text = title;
            cell.detailTextLabel.text = artist;
            cell.imageView.image = artwork;
            [cell.contentView addSubview:timeStampLabel];
//        });
//    });
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
