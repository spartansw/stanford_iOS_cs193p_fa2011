//
//  GraphingView.h
//  Calculator
//
//  Created by Kevin Lew on 7/23/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

@protocol GraphingViewDataSource

- (id) evaluateProgramForX:(double)x;
- (NSString *)descriptionOfProgram;

@end

#import <UIKit/UIKit.h>

@interface GraphingView : UIView

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@property (nonatomic, weak) id <GraphingViewDataSource> dataSource;
@property (nonatomic) BOOL graphLine;

- (void) pinch:(UIPinchGestureRecognizer *) gesture;
- (void) pan:(UIPanGestureRecognizer *) gesture;
- (void) tap:(UITapGestureRecognizer *) gesture;

@end
