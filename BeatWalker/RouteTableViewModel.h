//
//  RouteTableViewModel.h
//  BeatWalker
//
//  Created by Oliver Barnum on 1/30/14.
//  Copyright (c) 2014 BeatWalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteTableViewModel : NSObject<
    UITableViewDataSource, UITableViewDelegate>

+ (instancetype) model;

@property (nonatomic, copy) void (^reloadTableViewCell)();

@end
