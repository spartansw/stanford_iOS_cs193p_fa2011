//
//  VacationViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/20/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "VacationViewController.h"
#import "ManagedDocument.h"
#import "Vacation.h"
#import "MyVacationViewController.h"

@interface VacationViewController ()

@end

@implementation VacationViewController
@synthesize vacations = _vacations;

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *vacationDocumentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    // Retrieve all Core Data Vacation documents.
    NSError *error;
    self.vacations = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:vacationDocumentDirectory includingPropertiesForKeys:Nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    [self.tableView reloadData];
}

#pragma mark - Table view source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vacations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vacation = [VacationViewController parseVacationNameFromURL:[self.vacations objectAtIndex:indexPath.row]];
    return [super tableView:tableView cellIdentifier:@"VacationCell" cellTitle:vacation cellSubtitle:@""];
}

#pragma mark - Handle segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Vacation"] && [segue.destinationViewController isKindOfClass:[MyVacationViewController class]]) {
        MyVacationViewController *myVacation = segue.destinationViewController;
        myVacation.vacation = [VacationViewController parseVacationNameFromURL:[self.vacations objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
    }
}

+ (NSString *)parseVacationNameFromURL:(NSURL *)url {
    return [[[url path] componentsSeparatedByString:@"/"] lastObject];
}

@end
