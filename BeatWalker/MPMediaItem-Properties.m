/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "MPMediaItem-Properties.h"

/*
 NSString *const MPMediaItemPropertyPersistentID;      // filterable
 NSString *const MPMediaItemPropertyMediaType;         // filterable
 NSString *const MPMediaItemPropertyTitle;             // filterable
 NSString *const MPMediaItemPropertyAlbumTitle;        // filterable
 NSString *const MPMediaItemPropertyArtist;            // filterable
 NSString *const MPMediaItemPropertyAlbumArtist;       // filterable
 NSString *const MPMediaItemPropertyGenre;             // filterable
 NSString *const MPMediaItemPropertyComposer;          // filterable
 NSString *const MPMediaItemPropertyPlaybackDuration;
 NSString *const MPMediaItemPropertyAlbumTrackNumber;
 NSString *const MPMediaItemPropertyAlbumTrackCount;
 NSString *const MPMediaItemPropertyDiscNumber;
 NSString *const MPMediaItemPropertyDiscCount;
 NSString *const MPMediaItemPropertyArtwork;
 NSString *const MPMediaItemPropertyLyrics;
 NSString *const MPMediaItemPropertyIsCompilation;     // filterable
 
 NSString *const MPMediaItemPropertyPodcastTitle;     // filterable
 
 NSString *const MPMediaItemPropertyPlayCount;
 NSString *const MPMediaItemPropertySkipCount;
 NSString *const MPMediaItemPropertyRating;
 NSString *const MPMediaItemPropertyLastPlayedDate;
 */

@implementation MPMediaItem (Properties)

- (NSNumber*) persistentID
{
	return [self valueForProperty:MPMediaItemPropertyPersistentID];
}

- (NSInteger) mediaType
{
	return [[self valueForProperty:MPMediaItemPropertyMediaType] intValue];
}

- (NSString *) title
{
	return [self valueForProperty:MPMediaItemPropertyTitle];
}

- (NSString *) albumTitle
{
	return [self valueForProperty:MPMediaItemPropertyAlbumTitle];
}

- (NSString *) artist
{
	return [self valueForProperty:MPMediaItemPropertyArtist];
}

- (NSString *) albumArtist
{
	return [self valueForProperty:MPMediaItemPropertyAlbumArtist];	
}

- (NSString *) genre
{
	return [self valueForProperty:MPMediaItemPropertyGenre];	
}

- (NSString *) composer
{
	return [self valueForProperty:MPMediaItemPropertyComposer];	
}

- (double) playbackDuration
{
	return [[self valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
}

- (NSInteger) albumTrackNumber
{
	return [[self valueForProperty:MPMediaItemPropertyAlbumTrackNumber] intValue];	
}

- (NSInteger) albumTrackCount
{
	return [[self valueForProperty:MPMediaItemPropertyAlbumTrackCount] intValue];	
}

- (NSInteger) discNumber
{
	return [[self valueForProperty:MPMediaItemPropertyDiscNumber] intValue];	
}

- (NSInteger) discCount
{
	return [[self valueForProperty:MPMediaItemPropertyDiscCount] intValue];	
}

- (UIImage *) artwork
{
    MPMediaItemArtwork *artwork = [self valueForProperty: MPMediaItemPropertyArtwork];
    CGSize imageSize = CGSizeMake(256.0f, 256.0f);
    UIImage *artworkImage = [artwork imageWithSize:imageSize];
    
    if (!artworkImage) {
        artworkImage = [UIImage imageNamed:@"BlankArtwork"];
    }
    
	return [self imageByCropping:artworkImage toSize:imageSize];
}

- (UIImage *)imageByCropping:(UIImage *)image toSize:(CGSize)size
{
    double x = (image.size.width - size.width) / 2.0;
    double y = (image.size.height - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (UILabel*) cellTimeStampLabel {
    UILabel *label = [UILabel new];
    label.text = [self stringForTimeInterval:[self playbackDuration]];
    label.font = [UIFont systemFontOfSize:10.0];
    label.textColor = [UIColor beatWalkerSubtleTextColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    return label;
}

-(NSString*)stringForTimeInterval:(NSTimeInterval)timeInterval{
    NSInteger hours = floor(timeInterval /  (60 * 60) );
    
    CGFloat minute_divisor = (NSInteger)timeInterval % (60 * 60);
    NSInteger minutes = floor(minute_divisor / 60);
    
    CGFloat seconds_divisor = (NSInteger)timeInterval % 60;
    NSInteger seconds = ceil(seconds_divisor);
    
    NSString *hoursString = hours > 0 ? [NSString stringWithFormat:@"%li:", (long)hours] : @"";
    
    NSString *intervalString = [NSString stringWithFormat:@"%@%li:%02li", hoursString, (long)minutes, (long)seconds];
    
    return intervalString;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"<MPMediaItem\n\t   Artist: %@\n\t   Title: %@>", self.artist, self.title];
}

- (NSString *) lyrics
{
	return [self valueForProperty:MPMediaItemPropertyLyrics];
}

- (BOOL) isCompilation
{
	return [[self valueForProperty:MPMediaItemPropertyIsCompilation] boolValue];
}

- (NSString *) podcastTitle
{
	return [self valueForProperty:MPMediaItemPropertyPodcastTitle];
}

- (NSInteger) playCount
{
	return [[self valueForProperty:MPMediaItemPropertyPlayCount] intValue];
}

- (NSInteger) skipCount
{
	return [[self valueForProperty:MPMediaItemPropertySkipCount] intValue];
}

- (NSInteger) rating
{
	return [[self valueForProperty:MPMediaItemPropertyRating] intValue];
}

- (NSDate *) lastPlayedDate
{
	return [self valueForProperty:MPMediaItemPropertyLastPlayedDate];
}
@end
