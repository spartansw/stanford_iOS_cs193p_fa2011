//
//  VacationCategoryViewController.h
//  Flickr
//
//  Created by Kevin Lew on 8/23/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface VacationCategoryViewController : CoreDataTableViewController

@property (nonatomic, strong) NSString *vacation;

- (void)setupViewWithFetchRequest:(NSFetchRequest *)request;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender pictureFetchRequest:(NSFetchRequest *)request;
@end
