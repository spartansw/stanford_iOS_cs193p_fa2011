//
//  Photo+Flickr.m
//  Flickr
//
//  Created by Kevin Lew on 8/20/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tag+Photo.h"
#import "Location+Photo.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo inMangagedObjectContext:(NSManagedObjectContext *)context {
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || (([matches count] > 1))) {
        NSLog(@"%@", error);
    } else if ([matches count] == 0) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.name = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
  
        photo.location = [Location locationForPhoto:flickrInfo inMangagedObjectContext:context];
        [Tag tagsForPhotoTagAttribute:[flickrInfo objectForKey:FLICKR_TAGS] WithPhoto:photo inMangagedObjectContext:context];
    } else {
        photo = [matches lastObject];
    }
    return photo;
}

+ (BOOL)photoWithFlickrInfo:(NSString *)unique existsInManagedObjectContext:(NSManagedObjectContext *)context {
    return [Photo retrievePhotoWithID:unique inManagedObjectContext:context] != nil;
}

+ (Photo *)retrievePhotoWithID:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if ([matches count] == 1) {
        return [matches lastObject];
    } else {
        return nil;
    }
}

- (void)prepareForDeletion {
    if ([self.location.photos count] == 1) [self.managedObjectContext deleteObject:self.location];
    for (Tag *tag in self.tags) {
        tag.numPhotos = [NSNumber numberWithInt:[tag.numPhotos integerValue] - 1];
        if ([tag.numPhotos isEqualToNumber:[NSNumber numberWithInt:0]]) [self.managedObjectContext deleteObject:tag];
    }
}

@end
