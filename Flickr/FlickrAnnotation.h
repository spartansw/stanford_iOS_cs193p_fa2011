//
//  FlickrAnnotation.h
//  Flickr
//
//  Created by Kevin Lew on 8/8/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSDictionary *place;
@property (nonatomic) NSDictionary *image;

- (FlickrAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title withSubtitle:(NSString *)subtitle;

@end
