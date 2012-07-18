//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Kevin Lew on 7/17/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userIsEnteringAFloatingPointNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userIsEnteringAFloatingPointNumber = _userIsEnteringAFloatingPointNumber;
@synthesize brain = _brain;

- (CalculatorBrain *) brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.history.text = [[self.history.text stringByAppendingString:@" "] stringByAppendingString:self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsEnteringAFloatingPointNumber = NO;
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    self.history.text = [[self.history.text stringByAppendingString:@" "] stringByAppendingString:[sender currentTitle]];
    if (![[sender currentTitle] isEqualToString:@"π"]) self.history.text = [self.history.text stringByAppendingString:@" ="];
    double result = [self.brain performOperation:[sender currentTitle]];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)periodPressed:(UIButton *) sender {
    if (!self.userIsEnteringAFloatingPointNumber) {
        [self digitPressed:sender];
        self.userIsEnteringAFloatingPointNumber = YES;
    }
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.history.text = @"";
    [self.brain clearStack];
    self.userIsEnteringAFloatingPointNumber = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backPressed {
    if (self.display.text.length == 1) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.userIsEnteringAFloatingPointNumber = NO;
    } else {
        self.display.text = [self.display.text substringToIndex:self.display.text.length-1];
    }
}
- (IBAction)negationPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([[self.display.text substringToIndex:1] isEqualToString:@"-"]) {
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    } else {
        double result = [self.brain negateResult];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
