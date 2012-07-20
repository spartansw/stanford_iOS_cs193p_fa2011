//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Kevin Lew on 7/17/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;

@property (weak, nonatomic) IBOutlet UILabel *history;

@property (weak, nonatomic) IBOutlet UILabel *variables;

@property (weak, nonatomic) IBOutlet UILabel *error;

@end
