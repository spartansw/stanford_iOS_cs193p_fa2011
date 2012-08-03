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

@implementation FlickrTopPlacesController

- (void)viewWillAppear:(BOOL)animated
{
    super.tableValues = [FlickrFetcher topPlaces];
    [super viewWillAppear:animated];
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
    NSArray *location = [[topPlace objectForKey:@"_content"] componentsSeparatedByString:@", "];
    cell.textLabel.text = [location objectAtIndex:0];
    cell.detailTextLabel.text = [[location subarrayWithRange:NSMakeRange(1, [location count] - 1)] componentsJoinedByString:@", "] ;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Top Places Images"] && [segue.destinationViewController isKindOfClass:[FlickrTopPlacesImagesController class]]) {
        FlickrTopPlacesImagesController *destinationViewController = (FlickrTopPlacesImagesController *)segue.destinationViewController;
        NSInteger rowIndex = self.tableView.indexPathForSelectedRow.row;
        destinationViewController.place = [super.tableValues objectAtIndex:rowIndex];
        destinationViewController.title = [destinationViewController.place objectForKey:@"_content"];
    }
}

@end
