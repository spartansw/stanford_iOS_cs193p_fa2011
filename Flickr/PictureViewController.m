//
//  VacationViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/17/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "PictureViewController.h"
#import "ManagedDocument.h"
#import "Photo.h"
#import "VacationImageViewController.h"
#import "FlickrFetcher/FlickrFetcher.h"

@interface PictureViewController ()
@end

@implementation PictureViewController

@synthesize vacation = _vacation;
@synthesize pictureFetchRequest = _pictureFetchRequest;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Retrieve pictures from Core Data with query pictureFetchRequest using ManagedDocumentContext from self.vacation
    [ManagedDocument getSharedDocumentFor:self.vacation AndDo:^(UIManagedDocument *vacation) {
        self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:self.pictureFetchRequest
                                         managedObjectContext:vacation.
                                         managedObjectContext
                                         sectionNameKeyPath:nil cacheName:nil];
    }];
}

#pragma mark - Table view source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [super tableView:tableView cellIdentifier:@"PhotoCell" cellTitle:photo.name cellSubtitle:photo.subtitle];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Image"] && [segue.destinationViewController isKindOfClass:[VacationImageViewController class]]) {
        VacationImageViewController *destinationViewController = segue.destinationViewController;
        
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        // ImageViewController expects image passed as Flickr dictionary.
        NSMutableDictionary *flickrImage = [[NSMutableDictionary alloc] init];
        [flickrImage setValue:photo.name forKey:FLICKR_PHOTO_TITLE];
        [flickrImage setValue:photo.subtitle forKeyPath:FLICKR_PHOTO_DESCRIPTION];
        [flickrImage setValue:photo.unique forKey:FLICKR_PHOTO_ID];
        destinationViewController.image = flickrImage;
        destinationViewController.onVacation = YES;
    }
}

@end
