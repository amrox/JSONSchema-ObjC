//
//  JSONValidationContext.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSONSchemaDocument;
@class JSONSchemaValidationResult;

@interface JSONSchemaValidationContext : NSObject

/**
 @discussion Initializes with default validation logic
 */
- (id)init;

#pragma mark -

- (void) addSchema:(JSONSchemaDocument*)schema forURL:(NSURL*)url;

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchemaDocument*)schema;

@end
