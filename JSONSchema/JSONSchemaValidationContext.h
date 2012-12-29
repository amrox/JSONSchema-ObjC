//
//  JSONValidationContext.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSONSchema;
@class JSONSchemaValidationRules;

@interface JSONSchemaValidationContext : NSObject


/**
 @discussion Initializes with default rules
 */
- (id)init;

/**
 @discussion Initialize with custom rules
 */
- (id)initWithRules:(JSONSchemaValidationRules*)rules;

@property (nonatomic, retain, readonly) JSONSchemaValidationRules* rules;

#pragma mark -

- (void) addSchema:(JSONSchema*)schema forURL:(NSURL*)url;

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)errors;

@end
