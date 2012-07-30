//
//  GraphingView.m
//  Calculator
//
//  Created by Kevin Lew on 7/23/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "GraphingView.h"
#import "AxesDrawer.h"

@implementation GraphingView

@synthesize origin = _origin;
@synthesize scale = _scale;
@synthesize dataSource = _dataSource;
@synthesize graphLine = _graphLine;

/***** Axis Origin Accessors *****/
- (CGPoint) origin {
    if (!_origin.x && !_origin.y) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _origin.x = [defaults floatForKey:@"origin.x"];
        _origin.y = [defaults floatForKey:@"origin.y"];
    }
    if (_origin.x == 0 && _origin.y == 0) _origin = CGPointMake((self.bounds.origin.x+self.bounds.size.width)/2, (self.bounds.origin.y+self.bounds.size.height)/2);
    return _origin;
}

- (void) setOrigin:(CGPoint)origin {
    if (_origin.x != origin.x && _origin.y != origin.y) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:origin.x forKey:@"origin.x"];
        [defaults setFloat:origin.y forKey:@"origin.y"];
        _origin = origin;
        [self setNeedsDisplay];
    }
}

/***** Scale Accessors *****/
- (CGFloat) scale {
    if (!_scale) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _scale = [defaults floatForKey:@"scale"];
    }
    if (!_scale) _scale = 1.0;
    return _scale;
}

- (void) setScale:(CGFloat)scale {
    if (_scale != scale) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:scale forKey:@"scale"];
        _scale = scale;
        [self setNeedsDisplay];
    }
}

/***** Gesture Handlers *****/
- (void) pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void) pan:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void) tap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.origin = [gesture locationInView:self];
    }
}

/***** Draw Graph on Coordinate System *****/
- (void)drawRect:(CGRect)rect
{
    // Draw X axis and Y axis
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    // Pulled from drawHashMarksInRect:(25*2)== MIN_PIXELS_PER_HASHMARK.
    CGFloat pointsPerUnit = self.scale;
    int unitsPerHashmark = 25*2/pointsPerUnit;
    if (!unitsPerHashmark) unitsPerHashmark = 1;
    
    CGFloat pointsPerHashmark = unitsPerHashmark * pointsPerUnit;
    CGFloat pixelsPerHashmark = pointsPerHashmark * self.contentScaleFactor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    CGFloat drawOriginX = self.bounds.origin.x;
    int continuous = NO;
    for (CGFloat x = drawOriginX; x < drawOriginX + self.bounds.size.width; x += 1.0/self.contentScaleFactor) {
        CGFloat scaled_x = ((x-self.origin.x)/pixelsPerHashmark) * unitsPerHashmark;
        id scaled_y = [self.dataSource evaluateProgramForX:scaled_x];

        // Check if program returned an error
        if ([scaled_y isKindOfClass:[NSNumber class]]) {
            CGFloat y = self.origin.y - ([scaled_y floatValue]/unitsPerHashmark) * pixelsPerHashmark;
            
            if (continuous == NO) {
                CGContextMoveToPoint(context, x, y);
                if (!self.graphLine) CGContextFillRect(context, CGRectMake(x, y, 1.0/self.contentScaleFactor, 1.0/self.contentScaleFactor));
                continuous = YES;
            } else {
                if (self.graphLine) CGContextAddLineToPoint(context, x, y);
                CGContextMoveToPoint(context, x, y);
                if (!self.graphLine) CGContextFillRect(context, CGRectMake(x, y, 1.0/self.contentScaleFactor, 1.0/self.contentScaleFactor));
                continuous = YES;
            }
        } else {
            continuous = NO;
        }
    }
    CGContextStrokePath(context);
}

@end
