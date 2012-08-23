//
//  MyVacationViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/20/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "MyVacationViewController.h"
#import "ItineraryViewController.h"
#import "TagsViewController.h"

@interface MyVacationViewController ()

@end

@implementation MyVacationViewController

@synthesize vacation = _vacation;

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
        [segue.destinationViewController performSelector:@selector(setVacation:) withObject:self.vacation];
    }
}

#pragma mark - Interface Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
