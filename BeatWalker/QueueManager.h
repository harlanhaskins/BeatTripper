//
//  QueueManager.h
//  BeatTripper
//
//  Created by Harlan Haskins on 2/4/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPMediaItemCollection;

@interface QueueManager : NSObject

@property (nonatomic, readonly) MPMediaItemCollection *collection;
+ (instancetype) sharedManager;

@end
