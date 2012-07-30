//
//  RotatableViewController.m
//  Calculator
//
//  Created by Kevin Lew on 7/26/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "RotatableViewController.h"

@implementation RotatableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
