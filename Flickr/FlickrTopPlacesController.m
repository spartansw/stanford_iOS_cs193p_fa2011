//
//  FlickrTopPlacesController.m
//  Flickr
//
//  Created by Kevin Lew on 7/30/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "FlickrTopPlacesController.h"
#import "FlickrFetcher.h"
#import "FlickrTopPlacesImagesController.h"
#import "FlickrMapViewController.h"
#import "FlickrAnnotation.h"

@implementation FlickrTopPlacesController

- (void)loadView {
    [super loadView];
    [self refresh:self.navigationItem.leftBarButtonItem];
}

- (IBAction)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    dispatch_queue_t topPlacesQueue = dispatch_queue_create("download top places", NULL);
    dispatch_async(topPlacesQueue, ^{
        super.tableValues = [FlickrFetcher topPlaces];
//        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem = sender;
            [self.tableView reloadData];
        });
    });
    dispatch_release(topPlacesQueue);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Allocate subtitle table cell with disclosure indicator if does not exist.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlickrTopPlacesCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FlickrTopPlacesCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell text labels.
    NSDictionary *topPlace = [super.tableValues objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrTopPlacesController parseTitleFromLocation:topPlace];
    cell.detailTextLabel.text = [FlickrTopPlacesController parseSubtitleFromLocation:topPlace];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Top Places Images"] &&
        [segue.destinationViewController isKindOfClass:[FlickrTopPlacesImagesController class]]) {
        
        FlickrTopPlacesImagesController *destinationViewController = (FlickrTopPlacesImagesController *)segue.destinationViewController;
        NSInteger rowIndex = self.tableView.indexPathForSelectedRow.row;
        destinationViewController.place = [super.tableValues objectAtIndex:rowIndex];
        destinationViewController.title = [destinationViewController.place objectForKey:@"_content"];
        
    } else if ([segue.identifier isEqualToString:@"View Top Places Map"] && [segue.destinationViewController isKindOfClass:[FlickrMapViewController class]]) {
        
        FlickrMapViewController *destinationViewController = (FlickrMapViewController *)segue.destinationViewController;
        NSMutableArray *annotations = [[NSMutableArray alloc] init];
        for (NSDictionary *topPlace in super.tableValues) {
            CLLocationDegrees latitude = [[topPlace objectForKey:@"latitude"] doubleValue];
            CLLocationDegrees longitude = [[topPlace objectForKey:@"longitude"] doubleValue];
            FlickrAnnotation *point = [[FlickrAnnotation alloc]
                                       initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                       withTitle:[FlickrTopPlacesController parseTitleFromLocation:topPlace]
                                       withSubtitle:[FlickrTopPlacesController parseSubtitleFromLocation:topPlace]];
            point.place = topPlace;
            [annotations addObject:point];
        }
        destinationViewController.annotations = annotations;
        
    }
}

+ (NSString *)parseTitleFromLocation:(NSDictionary *)topPlace {
    NSArray *location = [[topPlace objectForKey:@"_content"] componentsSeparatedByString:@", "];
    return [location objectAtIndex:0];
}

+ (NSString *)parseSubtitleFromLocation:(NSDictionary *)topPlace {
    NSArray *location = [[topPlace objectForKey:@"_content"] componentsSeparatedByString:@", "];
    return [[location subarrayWithRange:NSMakeRange(1, [location count] - 1)] componentsJoinedByString:@", "];
}

@end
