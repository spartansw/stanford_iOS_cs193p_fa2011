//
//  ImageCache.m
//  Flickr
//
//  Created by Kevin Lew on 8/7/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "ImageCache.h"
#import "FlickrFetcher.h"

// Key to refer to Flickr image ID.
static NSString *UNIQUE_IMAGE_ID = @"id";
// Storage in bytes.
static int STORAGE_LIMIT = 10 * 2^20;
// Directory within application sandbox to store images.
static NSString *APPLICATION_CACHE_DIRECTORY = @"/flickr";

@interface ImageCache ()
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *applicationPath;
@end

@implementation ImageCache

@synthesize fileManager = _fileManager;
@synthesize applicationPath = _applicationPath;

// Construct the application directory path and return as a string.
- (NSString *)applicationPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:APPLICATION_CACHE_DIRECTORY];
    return cacheDirectory;
}

// Initialize image cache directory if it does not exist.
- (NSFileManager *)fileManager {
    if (!_fileManager) _fileManager = [NSFileManager defaultManager];
    
    NSError *fileError;
    if (![_fileManager fileExistsAtPath:self.applicationPath] &&
        ![_fileManager createDirectoryAtPath:self.applicationPath withIntermediateDirectories:NO attributes:nil error:&fileError]) {
        NSLog(@"%@",fileError);
    }
    
    return _fileManager;
}

+ (UIImage *)getImageForURL:(NSString *)url {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
}

// This method should only be called asynchronously.
- (UIImage *)getImageForKey:(NSDictionary *)imageKey {
    // Use unique image id supplied by Flickr as file name for image.
    NSString *imageFile = [self.applicationPath stringByAppendingFormat:@"/%@", [imageKey valueForKey:UNIQUE_IMAGE_ID]];
    
    // Load image from cache if exists, otherwise download and cache.
    NSData *data = [self.fileManager contentsAtPath:imageFile];
    UIImage *image;
    if (data) {
        image = [UIImage imageWithData:data];
    } else {
        NSLog(@"Downloading Full Image");
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:imageKey format:FlickrPhotoFormatLarge]]];
        [self cacheImage:image WithKey:imageFile];
    }
    return image;
}

- (void)cacheImage:(UIImage *)image WithKey:(NSString *)key {
    NSData *jpeg = UIImageJPEGRepresentation(image, 1);
    
    // Retrieve cached files with info on access dates and file sizes.
    NSArray *fileProperties = [[NSArray alloc] initWithObjects:NSURLContentAccessDateKey, NSURLFileSizeKey, nil];
    NSMutableArray *files = [[self.fileManager contentsOfDirectoryAtURL:[[NSURL alloc] initFileURLWithPath:self.applicationPath] includingPropertiesForKeys:fileProperties options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];
    
    // Calculate current cache size.
    int cacheSize = 0;
    for (int i = 0; i < [files count]; i++) {
        NSNumber *fileSize;
        [[files objectAtIndex:i] getResourceValue:&fileSize forKey:NSURLFileSizeKey error:nil];
        cacheSize += [fileSize integerValue];
    }
    
    // Delete files based on access date.
    [files sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSDate *date1, *date2;
        [obj1 getResourceValue:&date1 forKey:NSURLContentAccessDateKey error:nil];
        [obj2 getResourceValue:&date2 forKey:NSURLContentAccessDateKey error:nil];
        return [date2 compare:date1];
    }];

    // Delete until under cache size limit.
    while (cacheSize + jpeg.length > STORAGE_LIMIT && jpeg.length < STORAGE_LIMIT) {
        NSURL *evictee = [files objectAtIndex:0];
        [files removeObjectAtIndex:0];
        NSNumber *evicteeSize;
        [evictee getResourceValue:&evicteeSize forKey:NSURLFileSizeKey error:nil];
        [self.fileManager removeItemAtURL:evictee error:nil];
        cacheSize -= [evicteeSize integerValue];
    }
    
    // Cache the image.
    [self.fileManager createFileAtPath:key contents:UIImageJPEGRepresentation(image, 1) attributes:nil];
}

@end
