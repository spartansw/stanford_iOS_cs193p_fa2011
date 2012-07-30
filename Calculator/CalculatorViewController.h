//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Kevin Lew on 7/17/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"

@class CalculatorBrain;

@interface CalculatorViewController : RotatableViewController

@property (weak, nonatomic) IBOutlet UILabel *portraitDisplay;
@property (weak, nonatomic) IBOutlet UILabel *landscapeDisplay;

@property (weak, nonatomic) IBOutlet UILabel *portraitHistory;
@property (weak, nonatomic) IBOutlet UILabel *landscapeHistory;

@property (weak, nonatomic) IBOutlet UILabel *portraitError;
@property (weak, nonatomic) IBOutlet UILabel *landscapeError;

@property (nonatomic, strong) CalculatorBrain *brain;

@property (nonatomic, strong) NSDictionary *testVariableValues;

- (id)evaluateProgram;

@end
