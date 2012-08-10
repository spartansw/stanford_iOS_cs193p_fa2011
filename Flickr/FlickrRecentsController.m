//
//  FlickrRecentsController.m
//  Flickr
//
//  Created by Kevin Lew on 7/30/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "FlickrRecentsController.h"
#import "FlickrImageMapViewController.h"
#import "FlickrAnnotation.h"
#import "ImageViewController.h"

@interface FlickrRecentsController ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation FlickrRecentsController
@synthesize defaults = _defaults;

- (NSUserDefaults *) defaults {
    if (!_defaults) _defaults = [NSUserDefaults standardUserDefaults];
    return _defaults;
}

- (void) loadView {
    [super loadView];
    [self refresh:self.navigationItem.leftBarButtonItem];
}

- (IBAction)refresh:(id)sender {
    // Replace refresh button with spinner animation.
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t recentQueue = dispatch_queue_create("fetch recent pictures", NULL);
    dispatch_async(recentQueue, ^{
//        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        super.tableValues = [self.defaults objectForKey:@"history"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem = sender;
            [self.tableView reloadData];
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

@end