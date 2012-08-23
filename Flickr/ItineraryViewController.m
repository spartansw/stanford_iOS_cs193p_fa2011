//
//  ItineraryViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/20/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "ItineraryViewController.h"
#import "ManagedDocument.h"
#import "Location.h"
#import "PictureViewController.h"

@interface ItineraryViewController ()

@end

@implementation ItineraryViewController

@synthesize vacation = _vacation;

- (void)viewDidLoad
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES selector:@selector(compare:)]];
    
    [super setupViewWithFetchRequest:request];
}

#pragma mark - Table view source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *cellSubtitle = [NSString stringWithFormat:[location.photos count] == 1 ? @"%d photo" : @"%d photos", [location.photos count]];
    return [super tableView:tableView cellIdentifier:@"ItineraryCell" cellTitle:location.name cellSubtitle:cellSubtitle];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Location *location = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"location.name = [c]%@", location.name];
    
    [super prepareForSegue:segue sender:sender pictureFetchRequest:request];
}

@end
