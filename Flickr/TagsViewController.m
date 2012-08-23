//
//  TagsViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/21/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "TagsViewController.h"
#import "ManagedDocument.h"
#import "Tag+Photo.h"
#import "PictureViewController.h"

@interface TagsViewController ()

@end

@implementation TagsViewController

- (void)viewDidLoad
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"numPhotos" ascending:YES selector:@selector(compare:)]];
    [super setupViewWithFetchRequest:request];
}

#pragma mark - Table view source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *cellSubtitle = [NSString stringWithFormat:([tag.numPhotos isEqualToNumber:[NSNumber numberWithInt:1]] ? @"%@ photo" : @"%@ photos"), tag.numPhotos];
    
    return [super tableView:tableView cellIdentifier:@"TagsCell" cellTitle:tag.name cellSubtitle:cellSubtitle];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"tags.name CONTAINS [c]%@", tag.name];
    
    [super prepareForSegue:segue sender:sender pictureFetchRequest:request];
}

@end
