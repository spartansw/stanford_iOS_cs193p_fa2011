//
//  FlickrAnnotation.m
//  Flickr
//
//  Created by Kevin Lew on 8/8/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "FlickrAnnotation.h"

@implementation FlickrAnnotation
@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

@synthesize place = _place;
@synthesize image = _image;

- (FlickrAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title withSubtitle:(NSString *)subtitle {
    FlickrAnnotation *instance = [[FlickrAnnotation alloc] init];
    [instance setCoordinate:coordinate];
    instance.title = title;
    instance.subtitle = subtitle;
    return instance;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

@end
