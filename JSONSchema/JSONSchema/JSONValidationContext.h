//
//  JSONValidationContext.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSONSchema;

@interface JSONValidationContext : NSObject

- (void) addSchema:(JSONSchema*)schema forURL:(NSURL*)url;

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)errors;

@end
