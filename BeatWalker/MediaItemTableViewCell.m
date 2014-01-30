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

+ (instancetype) cellWithMediaItem:(MPMediaItem*)item containingTableView:(UITableView*)tableView {
    
    UIColor *deleteColor = [UIColor colorWithRed:239.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:1.0];
    NSMutableArray *utilityButtons = [NSMutableArray array];
    [utilityButtons sw_addUtilityButtonWithColor:deleteColor title:@"Delete"];
    
    MediaItemTableViewCell *cell = [[MediaItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SongCell" containingTableView:tableView leftUtilityButtons:nil rightUtilityButtons:utilityButtons];
    
    cell.item = item;
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.artist;
    
    cell.textLabel.textColor =
    cell.detailTextLabel.textColor = [UIColor beatWalkerTextColor];
    
    cell.imageView.image = item.artwork;
    [cell.imageView setClipsToBounds:YES];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.textLabel.width -= 15.0;
    
    cell.accessoryView = [UIView new];
    
    UILabel *timeStampLabel = [item cellTimeStampLabel];
    timeStampLabel.center = CGPointMake(tableView.width - 20.0, 44.0 / 2.0);
    
    [cell.contentView addSubview:timeStampLabel];
    
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
