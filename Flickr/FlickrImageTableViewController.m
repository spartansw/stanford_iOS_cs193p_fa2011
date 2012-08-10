//
//  FlickrImageTableViewController.m
//  Flickr
//  Class for displaying a list of images from the Flickr API property list and handling the display of the scroll view for the selected image.
//
//  Created by Kevin Lew on 8/1/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "FlickrImageTableViewController.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "FlickrImageMapViewController.h"
#import "FlickrAnnotation.h"

@implementation FlickrImageTableViewController

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Reuse empty subtitle prototype cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlickrImageCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FlickrImageCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Customize cell with image properties.
    NSDictionary *image = [self.tableValues objectAtIndex:indexPath.row];
    cell.textLabel.text = [ImageViewController retrievePictureTitleFromImage:image];
    cell.detailTextLabel.text = [image valueForKeyPath:@"description._content"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        ImageViewController *imageViewController = [self.splitViewController.viewControllers lastObject];
        imageViewController.image = [super.tableValues objectAtIndex:indexPath.row];
        [imageViewController reloadImage];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Location Images Map"]) {
        FlickrImageMapViewController *destinationViewController = (FlickrImageMapViewController *)segue.destinationViewController;
        NSMutableArray *annotations = [[NSMutableArray alloc] init];
        for (NSDictionary *topPlace in super.tableValues) {
            CLLocationDegrees latitude = [[topPlace objectForKey:@"latitude"] doubleValue];
            CLLocationDegrees longitude = [[topPlace objectForKey:@"longitude"] doubleValue];
            FlickrAnnotation *point = [[FlickrAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) withTitle:[ImageViewController retrievePictureTitleFromImage:topPlace] withSubtitle:[topPlace valueForKeyPath:@"description._content"]];
            point.image = topPlace;
            [annotations addObject:point];
        }
        destinationViewController.annotations = annotations;
    } else if ([segue.identifier isEqualToString:@"View Image"]) {
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        NSDictionary *image = [super.tableValues objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        imageViewController.image = image;
    }
}

@end
