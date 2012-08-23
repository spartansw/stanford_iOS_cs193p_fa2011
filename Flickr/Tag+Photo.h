//
//  Tag+Photo.h
//  Flickr
//
//  Created by Kevin Lew on 8/20/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "Tag.h"

@interface Tag (Photo)

+ (NSSet *)tagsForPhotoTagAttribute:(NSString *)photoTags WithPhoto:(Photo *)photo inMangagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getTagsForPhoto:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context;

@end
