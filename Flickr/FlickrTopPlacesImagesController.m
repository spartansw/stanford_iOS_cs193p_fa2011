//
//  FlickrTopPlacesImagesController.m
//  Flickr
//
//  Created by Kevin Lew on 7/31/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "FlickrTopPlacesImagesController.h"
#import "FlickrFetcher.h"
#import "FlickrMapViewController.h"
#import "FlickrAnnotation.h"
#import "ImageViewController.h"
#import "FlickrTopPlacesController.h"

@implementation FlickrTopPlacesImagesController
@synthesize place = _place;

- (void)loadView {
    [super loadView];
    [self refresh:self.navigationItem.rightBarButtonItem];
}

- (void)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t topPlacesImagesQueue = dispatch_queue_create("download place images", NULL);
    dispatch_async(topPlacesImagesQueue, ^{
        super.tableValues = [FlickrFetcher photosInPlace:self.place maxResults:50];
//        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *picture = [super.tableValues objectAtIndex:indexPath.row];
    [FlickrTopPlacesImagesController markPictureAsViewedRecently:picture];
    
    // Handle displaying the scroll view for the selected image.
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Location Images Map"]) {
        FlickrMapViewController *destinationViewController = (FlickrMapViewController *)segue.destinationViewController;
        destinationViewController.title = [FlickrTopPlacesController parseTitleFromLocation:self.place];
    }
    [super prepareForSegue:segue sender:sender];
}

+ (void)markPictureAsViewedRecently:(NSDictionary *)picture {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentList = [[defaults objectForKey:@"history"] mutableCopy];
    if (!recentList) recentList = [[NSMutableArray alloc] init];
    
    // Update user defaults to set selected picture as most recently viewed picture.
    if ([recentList containsObject:picture]) [recentList removeObject:picture];
    [recentList insertObject:picture atIndex:0];
    if ([recentList count] > 20) [recentList removeLastObject];
    [defaults setObject:recentList forKey:@"history"];
}

@end
