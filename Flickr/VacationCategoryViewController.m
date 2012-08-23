//
//  VacationCategoryViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/23/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "VacationCategoryViewController.h"
#import "ManagedDocument.h"
#import "PictureViewController.h"

@interface VacationCategoryViewController ()

@end

@implementation VacationCategoryViewController
@synthesize vacation = _vacation;

- (void)setupViewWithFetchRequest:(NSFetchRequest *)request
{
    [ManagedDocument getSharedDocumentFor:self.vacation AndDo:^(UIManagedDocument *vacation) {
        self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:request
                                         managedObjectContext:vacation.
                                         managedObjectContext
                                         sectionNameKeyPath:nil cacheName:nil];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender pictureFetchRequest:(NSFetchRequest *)request {
    if ([segue.identifier isEqualToString:@"View Pictures"] &&
        [segue.destinationViewController isKindOfClass:[PictureViewController class]]) {
        PictureViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.vacation = self.vacation;
        destinationViewController.title = [[self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]] name];
        destinationViewController.pictureFetchRequest = request;
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.fetchedResultsController.fetchedObjects count] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
