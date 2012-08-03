//
//  ImageViewController.m
//  Flickr
//
//  Created by Kevin Lew on 7/31/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "ImageViewController.h"
#import "FlickrFetcher.h"

#define MAX_ZOOM 2

@implementation ImageViewController
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize imageViewTitle = _imageViewTitle;

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize image = _image;

// First view assumed to be image for scroll view to zoom.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView.subviews objectAtIndex:0];
}

/***** Handle hiding the master controller in a toolbar button *****/
- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    return YES;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    barButtonItem.title = @"Pictures & Places";
    
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (self.splitViewBarButtonItem) [toolbarItems removeObject:self.splitViewBarButtonItem];
    if (barButtonItem) [toolbarItems insertObject:barButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    self.splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    
    [toolbarItems removeObjectAtIndex:0];
    self.toolbar.items = toolbarItems;
    self.splitViewBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// Handle adjusting the layout of the picture within the scroll view on rotation.
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self resizeZoom];
}

- (void)reloadImage {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:self.image format:FlickrPhotoFormatLarge]]];
    self.scrollView.zoomScale = 1.0;
    self.title = [ImageViewController retrievePictureTitleFromImage:self.image];
    self.imageViewTitle.title = [ImageViewController retrievePictureTitleFromImage:self.image];
    
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.imageView.image.size;
    [self resizeZoom];
}

- (void)resizeZoom {
    self.scrollView.minimumZoomScale = MIN(self.scrollView.bounds.size.width/self.imageView.image.size.width, self.scrollView.bounds.size.height/self.imageView.image.size.height);
    self.scrollView.maximumZoomScale = MAX_ZOOM;
    self.scrollView.zoomScale = MAX(self.scrollView.bounds.size.width/self.imageView.image.size.width, self.scrollView.bounds.size.height/self.imageView.image.size.height);

    self.scrollView.contentOffset = CGPointZero;
}

// Fallback for retrieving image title.
+ (NSString *)retrievePictureTitleFromImage:(NSDictionary *)property {
    NSString *title = [property valueForKey:@"title"];
    title = [title isEqualToString:@""] ? [property valueForKeyPath:@"description._content"] : title;
    return [title isEqualToString:@""] ? @"Unknown" : title;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.image) [self reloadImage];
}

- (void)viewDidUnload {
    [self setToolbar:nil];
    [self setImageViewTitle:nil];
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
