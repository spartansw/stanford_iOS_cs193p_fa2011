//
//  VacationImageViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/21/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "VacationImageViewController.h"
#import "ManagedDocument.h"
#import "Photo+Flickr.h"
#import "ImageCache.h"
#import "FlickrFetcher/FlickrFetcher.h"
#import "Location+Photo.h"
#import "Tag+Photo.h"

@interface VacationImageViewController ()
@end

@implementation VacationImageViewController
@synthesize visitButton;
@synthesize photo = _photo;
@synthesize onVacation = _onVacation;

static NSString *defaultVacation = @"My Vacation";

- (void)viewWillAppear:(BOOL)animated
{
    if (self.image) {
        [ManagedDocument getSharedDocumentFor:defaultVacation AndDo:^(UIManagedDocument *vacation) {
            BOOL loadFromCoreData = [Photo photoWithFlickrInfo:[self.image objectForKey:FLICKR_PHOTO_ID] existsInManagedObjectContext:vacation.managedObjectContext];
            if (loadFromCoreData) {
                self.visitButton.title = @"Unvisit";
                [super reloadImageUsing:^(NSDictionary *flickrImage) {
                    return [ImageCache getImageForURL:[Photo retrievePhotoWithID:[flickrImage objectForKey:FLICKR_PHOTO_ID] inManagedObjectContext:vacation.managedObjectContext].imageURL];
                }];
            } else {
                self.visitButton.title = @"Visit";
                [super viewWillAppear:animated];
            }
        }];
    }
}

- (IBAction)visitPlaceInImage:(id)sender {
    [ManagedDocument getSharedDocumentFor:defaultVacation AndDo:^(UIManagedDocument *vacation) {
        if ([self.visitButton.title isEqualToString:@"Visit"]) {
            self.visitButton.title = @"Unvisit";
            [vacation.managedObjectContext performBlock:^{
                [Photo photoWithFlickrInfo:self.image inMangagedObjectContext:vacation.managedObjectContext];
                [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
            }];
        } else {
            self.visitButton.title = @"Visit";
            [vacation.managedObjectContext deleteObject:[Photo retrievePhotoWithID:[self.image objectForKey:FLICKR_PHOTO_ID] inManagedObjectContext:vacation.managedObjectContext]];
            [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
            
            if (self.onVacation) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}


- (void)viewDidUnload {
    [self setVisitButton:nil];
    [super viewDidUnload];
}
@end
