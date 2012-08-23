//
//  ManagedDocument.h
//  Flickr
//
//  Created by Kevin Lew on 8/16/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completion_block_t)(UIManagedDocument *vacation);

@interface ManagedDocument : UIManagedDocument
+ (void)getSharedDocumentFor:(NSString *)vacationName AndDo:(completion_block_t)completion_code;
@end
