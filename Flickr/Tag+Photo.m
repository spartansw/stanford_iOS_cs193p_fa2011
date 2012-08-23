//
//  Tag+Photo.m
//  Flickr
//
//  Created by Kevin Lew on 8/20/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "Tag+Photo.h"

@implementation Tag (Photo)

+ (NSSet *)tagsForPhotoTagAttribute:(NSString *)photoTags WithPhoto:(Photo *)photo inMangagedObjectContext:(NSManagedObjectContext *)context {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSError *error;
    
    NSArray *tags = [photoTags componentsSeparatedByString:@" "];
    NSMutableSet *tagSet = [[NSMutableSet alloc] init];
    for (NSString *tagname in tags) {
        // Don't create tags if there aren't any or tag contains a colon.
        if (![tagname isEqualToString:@""] && [tagname rangeOfString:@":"].location == NSNotFound) {
            request.predicate = [NSPredicate predicateWithFormat:@"name = %@",[tagname capitalizedString]];
            request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *db_tag = [context executeFetchRequest:request error:&error];
            
            Tag *tag = nil;
            if (!db_tag || ([db_tag count] > 1)) {
                NSLog(@"%@, tag count:%d", error, [db_tag count]);
            } else if (![db_tag count]) {
                // Create a new Tag.
                tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
                tag.name = [tagname capitalizedString];
                tag.numPhotos = [NSNumber numberWithInt:1];
                tag.photos = [NSSet setWithObject:photo];
                [tagSet addObject:tag];
            } else {
                tag = [db_tag lastObject];
                [tag addPhotosObject:photo];
                tag.numPhotos = [NSNumber numberWithInt:tag.photos.count];
                [tagSet addObject:tag];
            }
        }
    }
    return tagSet;
}

+ (NSArray *)getTagsForPhoto:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY photos.unique = %@", unique];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error;
    NSArray *tags = [context executeFetchRequest:request error:&error];
    return tags;
}

@end
