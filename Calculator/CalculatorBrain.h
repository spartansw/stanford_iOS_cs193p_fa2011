//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Kevin Lew on 7/17/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

- (void) pushOperand:(double)operand;
- (void) pushOperation:(NSString *)operation;
- (void) clearStack;

+ (NSString *) descriptionOfProgram:(id)program;
+ (id) runProgram:(id)program;
+ (id) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

- (void) deleteTopOfStack;

@end
