//
//  FlickrImageMapViewController.m
//  Flickr
//
//  Created by Kevin Lew on 8/8/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "FlickrImageMapViewController.h"
#import "FlickrAnnotation.h"
#import "FlickrFetcher/FlickrFetcher.h"
#import "ImageViewController.h"
#import "FlickrTopPlacesImagesController.h"

@interface FlickrImageMapViewController ()

@end

@implementation FlickrImageMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    FlickrAnnotation *annotation = (FlickrAnnotation *)view.annotation;
    
    NSLog(@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude);
    dispatch_queue_t thumbnailQueue = dispatch_queue_create("fetch thumbnail", NULL);
    dispatch_async(thumbnailQueue, ^{
//        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        UIImage *thumbnail = nil;
        // Avoid downloading thumbnails if the popover is no longer selected.
        if (view.isSelected) {
            NSLog(@"Downloading Thumbnail: %c", view.isSelected);
            thumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:annotation.image format:FlickrPhotoFormatSquare]]];
        }
        // Need to check within the time the image is downloaded, annotation is still selected.
        if (view.isSelected) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Alloc thumbnailView");
                UIImageView *thumbnailView = [[UIImageView alloc] initWithImage:thumbnail];
                thumbnailView.frame = CGRectMake(0, 0, 30, 30);
                view.leftCalloutAccessoryView = thumbnailView;
            });
        }
    });
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    FlickrAnnotation *annotation = (FlickrAnnotation *)view.annotation;
    [FlickrTopPlacesImagesController markPictureAsViewedRecently:annotation.image];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        ImageViewController *imageViewController = [self.splitViewController.viewControllers lastObject];
        imageViewController.image = annotation.image;
        [imageViewController reloadImage];
    } else {
        [self performSegueWithIdentifier:@"View Image" sender:annotation.image];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Image"]) {
        ImageViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.image = sender;
    }
}

@end
