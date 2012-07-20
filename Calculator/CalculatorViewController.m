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

static NSDictionary *_testVariableValues;

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize variables = _variables;
@synthesize error = _error;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userIsEnteringAFloatingPointNumber = _userIsEnteringAFloatingPointNumber;
@synthesize brain = _brain;

- (CalculatorBrain *) brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

+ (NSDictionary *) testVariableValues {
    if (!_testVariableValues) _testVariableValues = [[NSDictionary alloc] init ];
    return [_testVariableValues copy];
}

+ (void) setTestVariableValues:(NSDictionary *)variableValues {
    _testVariableValues = variableValues;
}

- (IBAction) testPressed:(UIButton *)sender {
    NSString *button = [sender currentTitle];
    NSDictionary *variableValues;
    if ([button isEqualToString:@"Test 1"]) variableValues = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:3], @"A", [NSNumber numberWithInt:4], @"B", nil];
    if ([button isEqualToString:@"Test 2"]) variableValues = [[NSDictionary alloc] init];
    if ([button isEqualToString:@"Test 3"]) variableValues = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:-1], @"A", [NSNumber numberWithFloat:M_PI], @"B", [NSNumber numberWithFloat:1.5], @"C", nil];
    [CalculatorViewController setTestVariableValues:variableValues];
    [self evaluateProgram];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *vars = [[NSMutableSet alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [program count]; i++) {
            if ([self.testVariableValues objectForKey:[program objectAtIndex:i]] && ![vars containsObject:[program objectAtIndex:i]]) {
                
                [vars addObject:[program objectAtIndex:i]];
            }
        }
    }
    if ([vars count]) {
        return [vars copy];
    } else {
        return nil;
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    self.error.text = @"";
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
    self.error.text = @"";
    if (!self.userIsEnteringAFloatingPointNumber) {
        [self digitPressed:sender];
        self.userIsEnteringAFloatingPointNumber = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed {
    self.error.text = @"";
    self.display.text = @"0";
    self.history.text = @"";
    self.variables.text = @"";
    [self.brain clearStack];
    self.userIsEnteringAFloatingPointNumber = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backPressed {
    self.error.text = @"";
    if (self.display.text.length == 1) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.userIsEnteringAFloatingPointNumber = NO;
    } else {
        self.display.text = [self.display.text substringToIndex:self.display.text.length-1];
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
    self.error.text = @"";
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([[self.display.text substringToIndex:1] isEqualToString:@"-"]) {
            if ([self.display.text length] > 1) {
                self.display.text = [self.display.text substringFromIndex:1];
            } else {
                self.display.text = @"0";
            }
        } else {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    } else {
        if ([self.brain.program count] == 0) {
            self.display.text = @"-";
            self.userIsInTheMiddleOfEnteringANumber = YES;
        } else {
            [self.brain pushOperation:[sender currentTitle]];
            [self evaluateProgram];
        }
    }
}

- (void) evaluateProgram {
    id result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:[CalculatorViewController testVariableValues]];
    if ([self.brain.program count] == 0) result = [NSNumber numberWithFloat:0];
    if ([result isKindOfClass:[NSString class]]) {
        self.error.text = [NSString stringWithFormat:@"%@", result];
        self.display.text = @"";
    } else {
        self.display.text = [NSString stringWithFormat:@"%@", result];
        self.error.text = @"";
    }
    self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    NSSet *usedVars = [CalculatorViewController variablesUsedInProgram:self.brain.program];
    self.variables.text = @"";
    for (NSString *varKey in usedVars) {
        self.variables.text = [self.variables.text stringByAppendingFormat:@"%@ = %@ ", varKey, [[CalculatorViewController testVariableValues] objectForKey:varKey]];
    }
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [self setVariables:nil];
    [self setError:nil];
    [super viewDidUnload];
}
@end
