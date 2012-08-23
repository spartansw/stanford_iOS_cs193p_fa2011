//
//  Location+Photo.m
//  Flickr
//
//  Created by Kevin Lew on 8/21/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "Location+Photo.h"
#import "FlickrFetcher/FlickrFetcher.h"
#import "Photo+Flickr.h"

@implementation Location (Photo)

+ (Location *)locationForPhoto:(NSDictionary *)flickrInfo inMangagedObjectContext:(NSManagedObjectContext *)context {
    Location *location = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || (([matches count] > 1))) {
        NSLog(@"%@", error);
    } else if ([matches count] == 0) {
        location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        location.name = [flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME];
        location.creationDate = [NSDate dateWithTimeIntervalSinceNow:0];
        
    } else {
        location = [matches lastObject];
    }
    
    return location;
}

@end
