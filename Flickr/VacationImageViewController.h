//
//  VacationImageViewController.h
//  Flickr
//
//  Created by Kevin Lew on 8/21/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "ImageViewController.h"
#import "Photo+Flickr.h"

@interface VacationImageViewController : ImageViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *visitButton;
@property (nonatomic) Photo *photo;
@property (nonatomic) BOOL onVacation;

@end
