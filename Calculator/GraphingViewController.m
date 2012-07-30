//
//  GraphingViewController.m
//  Calculator
//
//  Created by Kevin Lew on 7/23/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "GraphingViewController.h"
#import "GraphingView.h"
#import "CalculatorBrain.h"

@interface GraphingViewController () <GraphingViewDataSource>
@end

@implementation GraphingViewController
@synthesize canvas = _canvas;
@synthesize program = _program;

@synthesize iPadGraphMode = _iPadGraphMode;
@synthesize iPhoneGraphMode = _iPhoneGraphMode;

/***** Data Model *****/
- (void) setProgram:(NSArray *)program {
    _program = program;
    self.title = [CalculatorBrain descriptionOfProgram:program];
    if (self.canvas) [self.canvas setNeedsDisplay];
}

/***** Setup GraphingView Gestures, add self as Data Source Handler *****/
- (void) setCanvas:(GraphingView *)canvas {
    _canvas = canvas;
    [self.canvas addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.canvas action:@selector(pan:)]];
    [self.canvas addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.canvas action:@selector(pinch:)]];
    
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.canvas action:@selector(tap:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.canvas addGestureRecognizer:tripleTap];
    
    self.canvas.dataSource = self;
}

/***** Handle GraphingView's Data Requests *****/
- (id) evaluateProgramForX:(double)x {
    NSDictionary *variableValues = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:x], @"X", nil];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}

- (NSString *)descriptionOfProgram {
    return [CalculatorBrain descriptionOfProgram:self.program];
}

/***** Handle Navigation Bar button for switching between dot/line mode for graphing *****/
- (IBAction)changeGraphingMode:(id)sender {
    self.iPhoneGraphMode.title = self.canvas.graphLine ? @"Switch to Line": @"Switch to Dot";
    self.iPadGraphMode.title = self.canvas.graphLine ? @"Switch to Line": @"Switch to Dot";
    self.canvas.graphLine = self.canvas.graphLine ? NO : YES;
    [self.canvas setNeedsDisplay];
}


- (void)viewDidUnload {
    [self setIPadGraphMode:nil];
    [self setIPhoneGraphMode:nil];
    [super viewDidUnload];
}
@end
