//
//  FlickrTopPlacesImagesController.h
//  Flickr
//
//  Created by Kevin Lew on 7/31/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrImageTableViewController.h"

@interface FlickrTopPlacesImagesController : FlickrImageTableViewController

@property (nonatomic, strong) NSDictionary *place;

+ (void)markPictureAsViewedRecently:(NSDictionary *)picture;

@end
