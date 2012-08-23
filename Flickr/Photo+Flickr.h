//
//  Photo+Flickr.h
//  Flickr
//
//  Created by Kevin Lew on 8/20/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo inMangagedObjectContext:(NSManagedObjectContext *)context;
+ (BOOL)photoWithFlickrInfo:(NSDictionary *)flickrInfo existsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Photo *)retrievePhotoWithID:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context;

@end
