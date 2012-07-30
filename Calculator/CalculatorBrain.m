//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kevin Lew on 7/17/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *programStack;
@end


@implementation CalculatorBrain

/************** Accessors ***************/
@synthesize programStack = _programStack;

- (NSMutableArray *) programStack {
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id) program {
    return [self.programStack copy];
}

/****************************************/

- (void) pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) pushOperation:(NSString *)operation {
    [self.programStack addObject:operation];
}

- (void) deleteTopOfStack {
    [self.programStack removeLastObject];
}

+ (NSString *) descriptionOfProgram:(id)program {
    NSString *desc = @"";
    if ([program isKindOfClass:[NSArray class]]) {
        NSMutableArray *stash = [program mutableCopy];
        while ([stash count] > 0) {
            if ([desc isEqualToString:@""]) {
                desc = [CalculatorBrain parseProgram:stash];
            } else {
                desc = [@"" stringByAppendingFormat:@"%@, %@", [CalculatorBrain parseProgram:stash], desc];
            }
        }
    }
    return desc;
}

+ (NSString *) parseProgram:(NSMutableArray *)stack {
    if ([stack count] == 0) return @"nil";
    id next = [stack lastObject];
    [stack removeLastObject];
    NSString *desc = [NSString stringWithFormat:@"%@", next];
    if ([next isKindOfClass:[NSString class]]) {
        if ([CalculatorBrain isUnaryOp:next]) {
            NSString *operand = [CalculatorBrain parseProgram:stack];
            if ([next isEqualToString:@"+/-"]) next = @"-";
            if ([[operand substringToIndex:1] isEqualToString:@"("]) {
                desc = [next stringByAppendingFormat:@"%@", operand];
            } else {
                desc = [next stringByAppendingFormat:@"(%@)", operand];
            }
        } else if ([CalculatorBrain isDivOrSub:next] ||
                   [CalculatorBrain isMultOrAdd:next]) {
            NSString *arg2 = [CalculatorBrain parseProgram:stack];
            NSString *arg1 = [CalculatorBrain parseProgram:stack];
            if ([arg1 isEqualToString:@"nil"]) {
                NSString *temp = arg2;
                arg2 = arg1;
                arg1 = temp;
            }
            if ([CalculatorBrain isDivOrSub:next]) {
                desc = [@"" stringByAppendingFormat:@"(%@ %@ %@)", arg1, next, arg2];
            } else if ([CalculatorBrain isMultOrAdd:next]) {
                desc = [@"" stringByAppendingFormat:@"(%@ %@ %@)", arg1, next, arg2];
            }
        }
    }
    return desc;
}

+ (BOOL) isBinaryOp:(NSString *)op {
    return [CalculatorBrain isMultOrAdd:op] || [CalculatorBrain isDivOrSub:op];
}

+ (BOOL) isDivOrSub:(NSString *)op {
    return [op isEqualToString:@"/"] || [op isEqualToString:@"-"];
}

+ (BOOL) isMultOrAdd:(NSString *)op {
    return [op isEqualToString:@"*"] || [op isEqualToString:@"+"];
}

+ (BOOL) isUnaryOp:(NSString *)op {
    NSArray *ops = [NSArray arrayWithObjects:@"sin", @"cos", @"sqrt", @"+/-", nil];
    return [ops containsObject:op];
}

+ (id) runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (id) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        for (int i = 0; i < [stack count]; i++) {
            if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]] &&
                [variableValues objectForKey:[stack objectAtIndex:i]]) {
                
                [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:[stack objectAtIndex:i]]];
            }
        }
    }
    return [self popOperandOffStack:stack];
}

/***** Handle calculator operations *****/

+ (id) popOperandOffStack:(NSMutableArray *)stack {
    id result = [NSNumber numberWithFloat:0];

    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [NSNumber numberWithFloat:[topOfStack doubleValue]];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([CalculatorBrain isBinaryOp:operation]) {
            id arg2 = [self popOperandOffStack:stack];
            id arg1 = [self popOperandOffStack:stack];
            if ([arg2 isKindOfClass:[NSString class]]) return arg2;
            if ([arg1 isKindOfClass:[NSString class]]) return arg1;
            
            if ([@"+" isEqualToString:operation]) {
                result = [NSNumber numberWithFloat:[arg1 doubleValue]+[arg2 doubleValue]];
            } else if ([@"*" isEqualToString:operation ]) {
                result = [NSNumber numberWithFloat:[arg1 doubleValue] * [arg2 doubleValue]];
            } else if ([@"-" isEqualToString:operation]) {
                result = [NSNumber numberWithFloat:[arg1 doubleValue] - [arg2 doubleValue]];
            } else if ([@"/" isEqualToString:operation]) {
                if ([arg2 doubleValue] == 0) return @"Error: Division By Zero";
                result = [NSNumber numberWithFloat:[arg1 doubleValue] / [arg2 doubleValue]];
            }
        } else if ([CalculatorBrain isUnaryOp:operation]) {
            id arg1 = [self popOperandOffStack:stack];
            if ([arg1 isKindOfClass:[NSString class]]) return arg1;
            
            if ([@"sin" isEqualToString:operation]) {
                result = [NSNumber numberWithFloat:sin([arg1 doubleValue])];
            } else if ([@"cos" isEqualToString:operation]) {
                result = [NSNumber numberWithFloat:cos([arg1 doubleValue])];
            } else if ([@"sqrt" isEqualToString:operation]) {
                if ([arg1 doubleValue] < 0) return @"Error: Square Root of a Negative Number";
                result = [NSNumber numberWithFloat:sqrt([arg1 doubleValue])];
            } else if ([@"+/-" isEqualToString:operation]) {
                result = [NSNumber numberWithFloat:[arg1 doubleValue] * -1];
            }
        } else if ([@"π" isEqualToString:operation]) {
            result = [NSNumber numberWithFloat:M_PI];
        }
    }
    
    if (topOfStack == nil) {
        return @"Error: Insufficient Arguments";
    } else {
        return result;
    }
}

- (void) clearStack {
    [self.programStack removeAllObjects];
}

@end
