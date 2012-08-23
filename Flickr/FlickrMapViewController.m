//
//  FlickrMapViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/8/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "FlickrMapViewController.h"
#import "FlickrAnnotation.h"
#import "FlickrTopPlacesImagesController.h"

@interface FlickrMapViewController ()

@end

#define MAX_LATITUDE_SPAN 180
#define MAX_LONGITUDE_SPAN 360
#define ANNOTATION_PADDING 1.15

@implementation FlickrMapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;

- (void)viewWillAppear:(BOOL)animated
{
    self.mapView.delegate = self;
    [self.mapView addAnnotations:self.annotations];
    
    // Find outermost map pins to fit zoom.
    CLLocationDegrees minLatitude = 90, maxLatitude = -90, minLongitude = 180, maxLongitude = -180;
    for (id <MKAnnotation> result in self.annotations) {
        CLLocationCoordinate2D location = [result coordinate];
        if (location.latitude <= minLatitude) minLatitude = location.latitude;
        if (location.latitude >= maxLatitude) maxLatitude = location.latitude;
        if (location.longitude <= minLongitude) minLongitude = location.longitude;
        if (location.longitude >= maxLongitude) maxLongitude = location.longitude;
    }

    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((minLatitude+maxLatitude)/2, (minLongitude+maxLongitude)/2);
    
    MKCoordinateSpan initialMapSpan;
    CLLocationDegrees latitudeDelta = maxLatitude-minLatitude;
    CLLocationDegrees longitudeDelta = maxLongitude-minLongitude;
    initialMapSpan = MKCoordinateSpanMake(latitudeDelta*ANNOTATION_PADDING, longitudeDelta*ANNOTATION_PADDING);
    initialMapSpan.latitudeDelta = (initialMapSpan.latitudeDelta > MAX_LATITUDE_SPAN) ? MAX_LATITUDE_SPAN : initialMapSpan.latitudeDelta;
    initialMapSpan.longitudeDelta = (initialMapSpan.longitudeDelta > MAX_LONGITUDE_SPAN) ? MAX_LONGITUDE_SPAN : initialMapSpan.longitudeDelta;
    
    [self.mapView setRegion:MKCoordinateRegionMake(centerCoordinate, initialMapSpan)];
}

// Generate annotation pin views in a similar fashion to table cell views.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapPin"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapPin"];
        aView.canShowCallout = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.rightCalloutAccessoryView = button;
    } else {
        aView.annotation = annotation;
    }
    return aView;
}

- (void)viewDidUnload
{
    self.mapView.delegate = nil;
    [self setMapView:nil];
    [super viewDidUnload];
}

// Release delegate to avoid crash when user rapidly zooms and switches screens
- (void)viewWillDisappear:(BOOL)animated {
    self.mapView.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    FlickrAnnotation *annotation = (FlickrAnnotation *)view.annotation;
    [self performSegueWithIdentifier:@"View Top Places Images" sender:annotation.place];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Top Places Images"]) {
        FlickrTopPlacesImagesController *destinationViewController = (FlickrTopPlacesImagesController *)segue.destinationViewController;
        destinationViewController.place = sender;
        destinationViewController.title = [destinationViewController.place objectForKey:@"_content"];
    }
}

@end
