//
//  Location+Photo.h
//  Flickr
//
//  Created by Kevin Lew on 8/21/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "Location.h"

@interface Location (Photo)

+ (Location *)locationForPhoto:(NSDictionary *)flickrInfo inMangagedObjectContext:(NSManagedObjectContext *)context;

@end
