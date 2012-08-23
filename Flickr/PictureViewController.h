//
//  VacationViewController.h
//  Flickr
//
//  Created by Kevin Lew on 8/17/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VacationCategoryViewController.h"

@interface PictureViewController : VacationCategoryViewController

@property (nonatomic, strong) NSString *vacation;
@property (nonatomic, strong) NSFetchRequest *pictureFetchRequest;

@end
