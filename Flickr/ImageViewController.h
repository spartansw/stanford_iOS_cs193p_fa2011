//
//  ImageViewController.h
//  Flickr
//
//  Created by Kevin Lew on 7/31/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) UIBarButtonItem *splitViewBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *imageViewTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSDictionary *image;

+ (NSString *)retrievePictureTitleFromImage:(NSDictionary *)property;
-(void)reloadImage;

@end
