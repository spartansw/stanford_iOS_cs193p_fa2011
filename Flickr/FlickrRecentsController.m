//
//  FlickrRecentsController.m
//  Flickr
//
//  Created by Kevin Lew on 7/30/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "FlickrRecentsController.h"

@interface FlickrRecentsController ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation FlickrRecentsController
@synthesize defaults = _defaults;

- (NSUserDefaults *) defaults {
    if (!_defaults) _defaults = [NSUserDefaults standardUserDefaults];
    return _defaults;
}

// Update list when displayed.
- (void)viewWillAppear:(BOOL)animated {
    dispatch_queue_t recentQueue = dispatch_queue_create("fetch recent pictures", NULL);
    dispatch_async(recentQueue, ^{
        super.tableValues = [self.defaults objectForKey:@"history"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

@end
