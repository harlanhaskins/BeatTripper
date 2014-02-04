//
//  QueueManager.m
//  BeatTripper
//
//  Created by Harlan Haskins on 2/4/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//  Distributed under the MIT License
//

#import "QueueManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface QueueManager ()

@property (nonatomic) MPMediaItemCollection *collection;

@end

@implementation QueueManager

+ (instancetype) sharedManager {
    static dispatch_once_t once;
    static QueueManager *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

+ (instancetype) new {
    QueueManager *queueManager = [[QueueManager alloc] init];
    [queueManager cacheMediaItems];
    
    // Stop playback if music is playing.
    [[MPMusicPlayerController iPodMusicPlayer] stop];
    return queueManager;
}

- (void) cacheMediaItems {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery items];
        songQuery = nil;
    });
}

- (void) loadQueueWithCompletion:(void (^)(MPMediaItemCollection *collection))completion {
    // Load songs in the background.
    dispatch_queue_t queue = dispatch_queue_create("SongLoading", NULL);
    dispatch_async(queue, ^{
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        MPMediaItemCollection *collection = [self shuffledCollectionWithMediaQuery:songQuery];
        self.collection = collection;
        completion(collection);
    });
}

- (MPMediaItemCollection*) shuffledCollectionWithMediaQuery:(MPMediaQuery*)query {
    NSArray *querySongsArray = [query items];
    
    NSMutableArray *songsArray = [NSMutableArray array];
    
    NSInteger numberOfCollections = [query items].count;
    NSInteger highestNumberOfItems = 400;
    NSInteger numberOfItems = numberOfCollections >= highestNumberOfItems ? highestNumberOfItems : numberOfCollections;
    for (int i = 0; i < numberOfItems; i++) {
        MPMediaItem *song;
        do {
            NSInteger randomIndex = arc4random_uniform((u_int32_t)[querySongsArray count]);
            song = querySongsArray[randomIndex];
        }
        while ([songsArray indexOfObject:song] != NSNotFound);
        [songsArray addObject:song];
    }
    
    MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:songsArray];
    return collection;
}

@end
