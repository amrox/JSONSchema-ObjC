//
//  JSONValidationContext.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSONSchema;
@class JSONSchemaValidationLogic;
@class JSONSchemaValidationResult;

@interface JSONSchemaValidationContext : NSObject

/**
 @discussion Initializes with default validation logic
 */
- (id)init;

#pragma mark -

- (void) addSchema:(JSONSchema*)schema forURL:(NSURL*)url;

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchema*)schema;

@end
