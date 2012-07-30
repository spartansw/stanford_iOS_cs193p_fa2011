//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Kevin Lew on 7/17/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphingViewController.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userIsEnteringAFloatingPointNumber;
@end

static BOOL isLandscape = NO;

@implementation CalculatorViewController

// Output Display Labels: portrait(both), landscape(iPhone)
@synthesize portraitDisplay = _portraitDisplay;
@synthesize landscapeDisplay = _landscapeDisplay;
@synthesize portraitHistory = _portraitHistory;
@synthesize landscapeHistory = _landscapeHistory;
@synthesize portraitError = _portraitError;
@synthesize landscapeError = _landscapeError;

// Digit input state indicators
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userIsEnteringAFloatingPointNumber = _userIsEnteringAFloatingPointNumber;

@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *) brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSDictionary *) testVariableValues {
    if (!_testVariableValues) _testVariableValues = [[NSDictionary alloc] init ];
    return [_testVariableValues copy];
}

- (void) setTestVariableValues:(NSDictionary *)variableValues {
    _testVariableValues = variableValues;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    self.portraitError.text = @"";
    self.landscapeError.text = @"";
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.portraitDisplay.text = [self.portraitDisplay.text stringByAppendingString:digit];
        self.landscapeDisplay.text = [self.landscapeDisplay.text stringByAppendingString:digit];
    } else {
        self.portraitDisplay.text = digit;
        self.landscapeDisplay.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.portraitDisplay.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsEnteringAFloatingPointNumber = NO;
    [self evaluateProgram];
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self.brain pushOperation:[sender currentTitle]];
    [self evaluateProgram];
}

- (IBAction)periodPressed:(UIButton *) sender {
    self.portraitError.text = @"";
    self.landscapeError.text = @"";
    if (!self.userIsEnteringAFloatingPointNumber) {
        [self digitPressed:sender];
        self.userIsEnteringAFloatingPointNumber = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed {
    self.portraitError.text = @"";
    self.portraitDisplay.text = @"0";
    self.portraitHistory.text = @"";
    self.landscapeError.text = @"";
    self.landscapeDisplay.text = @"0";
    self.landscapeHistory.text = @"";
    [self.brain clearStack];
    self.userIsEnteringAFloatingPointNumber = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backPressed {
    self.portraitError.text = @"";
    self.landscapeError.text = @"";
    if (self.portraitDisplay.text.length == 1) {
        self.portraitDisplay.text = @"0";
        self.landscapeDisplay.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.userIsEnteringAFloatingPointNumber = NO;
    } else {
        self.portraitDisplay.text = [self.portraitDisplay.text substringToIndex:self.portraitDisplay.text.length-1];
        self.landscapeDisplay.text = [self.landscapeDisplay.text substringToIndex:self.landscapeDisplay.text.length-1];
    }
}

- (IBAction)undoPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self backPressed];
    } else {
        [self.brain deleteTopOfStack];
        [self evaluateProgram];
    }
}

- (IBAction)negationPressed:(UIButton *)sender {
    self.portraitError.text = @"";
    self.landscapeError.text = @"";
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([[self.portraitDisplay.text substringToIndex:1] isEqualToString:@"-"]) {
            if ([self.portraitDisplay.text length] > 1) {
                self.portraitDisplay.text = [self.portraitDisplay.text substringFromIndex:1];
                self.landscapeDisplay.text = [self.landscapeDisplay.text substringFromIndex:1];
            } else {
                self.portraitDisplay.text = @"0";
                self.landscapeDisplay.text = @"0";
            }
        } else {
            self.portraitDisplay.text = [@"-" stringByAppendingString:self.portraitDisplay.text];
            self.landscapeDisplay.text = [@"-" stringByAppendingString:self.landscapeDisplay.text];
        }
    } else {
        if ([self.brain.program count] == 0) {
            self.portraitDisplay.text = @"-";
            self.landscapeDisplay.text = @"-";
            self.userIsInTheMiddleOfEnteringANumber = YES;
        } else {
            [self.brain pushOperation:[sender currentTitle]];
            [self evaluateProgram];
        }
    }
}

- (id) evaluateProgram {
    id result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    if ([self.brain.program count] == 0) result = [NSNumber numberWithFloat:0];
    if ([result isKindOfClass:[NSString class]]) {
        self.portraitError.text = [NSString stringWithFormat:@"%@", result];
        self.landscapeError.text = [NSString stringWithFormat:@"%@", result];
        self.portraitDisplay.text = @"";
        self.landscapeDisplay.text = @"";
    } else {
        self.portraitDisplay.text = [NSString stringWithFormat:@"%@", result];
        self.landscapeDisplay.text = [NSString stringWithFormat:@"%@", result];
        self.portraitError.text = @"";
        self.landscapeError.text = @"";
    }
    self.portraitHistory.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.landscapeHistory.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    return result;
}

/***** Set program data for GraphingViewController: iPhone specific as iPad does not segue *****/
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowLandscapeGraph"] || [segue.identifier isEqualToString:@"ShowPortraitGraph"]) {
        [segue.destinationViewController setProgram:self.brain.program];
    }
}

/***** Set program data for GraphingViewController: iPad specific since segue does not set program data *****/
- (IBAction)doGraph:(id)sender {
    id svc = [self.splitViewController.viewControllers lastObject];
    if ([svc isKindOfClass:[UINavigationController class]] && [[[svc viewControllers] objectAtIndex:0] isKindOfClass:[GraphingViewController class]]) {
        GraphingViewController *gvc = [[svc viewControllers] objectAtIndex:0];
        gvc.program = self.brain.program;
    }
}

/***** Change Calculator layout on orientation change *****/
- (void)awakeFromNib {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    // Don't load the landscape view if on iPad.
    id svc = [self.splitViewController.viewControllers lastObject];
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isLandscape && !svc) {
        NSArray *subviews = self.view.subviews;
        UIView *view1 = [subviews objectAtIndex:0];
        UIView *view2 = [subviews objectAtIndex:1];
        [view1 setHidden:([view1 isHidden] ? NO : YES)];
        [view2 setHidden:([view2 isHidden] ? NO : YES)];
        isLandscape = YES;
    } else if (UIDeviceOrientationIsPortrait(deviceOrientation) && isLandscape && !svc) {
        NSArray *subviews = self.view.subviews;
        UIView *view1 = [subviews objectAtIndex:0];
        UIView *view2 = [subviews objectAtIndex:1];
        [view1 setHidden:([view1 isHidden] ? NO : YES)];
        [view2 setHidden:([view2 isHidden] ? NO : YES)];
        isLandscape = NO;
    }
}
 
- (void)viewDidUnload {
    [self setPortraitDisplay:nil];
    [self setPortraitHistory:nil];
    [self setPortraitError:nil];
    [self setLandscapeDisplay:nil];
    [self setLandscapeHistory:nil];
    [self setLandscapeError:nil];
    [super viewDidUnload];
}
@end
