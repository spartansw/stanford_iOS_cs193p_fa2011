//
//  ManagedDocument.m
//  Flickr
//
//  Created by Kevin Lew on 8/16/12.
//  Copyright (c) 2012 Spartan Software, Inc. All rights reserved.
//

#import "ManagedDocument.h"

@implementation ManagedDocument

static NSMutableDictionary *sharedDocuments;

+ (void)getSharedDocumentFor:(NSString *)vacationName AndDo:(completion_block_t)completion_code {
    if (!sharedDocuments) {
        sharedDocuments = [[NSMutableDictionary alloc] init];
    }
    // Get the vacation document on file.
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:vacationName];
    
    // Use the file if already loaded; otherwise create new managed doc.
    UIManagedDocument *document = [sharedDocuments objectForKey:vacationName];
    if (!document) {
        document = [[UIManagedDocument alloc] initWithFileURL:url];
        [sharedDocuments setValue:document forKey:vacationName];
    }
    
    // Create/Open/Use the document and pass to completion code.
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                completion_code(document);
            } else {
                NSLog(@"Problem with creating document at %@", [url absoluteString]);
            }
        }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                completion_code(document);
            } else {
                NSLog(@"Problem with opening document at %@", [url absoluteString]);
            }
        }];
    } else if (document.documentState == UIDocumentStateNormal) {
        completion_code(document);
    }
}
    
@end
