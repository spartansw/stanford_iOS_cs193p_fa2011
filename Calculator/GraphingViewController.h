//
//  GraphingViewController.h
//  Calculator
//
//  Created by Kevin Lew on 7/23/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"

@class GraphingView;

@interface GraphingViewController : RotatableViewController

@property (weak, nonatomic) IBOutlet GraphingView *canvas;
@property (nonatomic, strong) NSArray *program;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iPadGraphMode;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iPhoneGraphMode;

@end
