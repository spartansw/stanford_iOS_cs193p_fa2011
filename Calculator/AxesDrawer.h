//
//  AxesDrawer.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AxesDrawer : NSObject

+ (void)drawAxesInRect:(CGRect)bounds
         originAtPoint:(CGPoint)axisOrigin
                 scale:(CGFloat)pointsPerUnit;

+ (void)drawString:(NSString *)text atPoint:(CGPoint)location withAnchor:(int)anchor;
+ (BOOL) rect:(CGRect)bounds ContainsPoint:(CGPoint)point;

@end