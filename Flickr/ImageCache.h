//
//  ImageCache.h
//  Flickr
//
//  Created by Kevin Lew on 8/7/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

- (UIImage *)getImageForKey:(NSDictionary *)image;
+ (UIImage *)getImageForURL:(NSString *)url;

@end
