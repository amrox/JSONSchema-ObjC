//
//  JSONSchemaValidationRules.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 12/29/12.
//
//

#import <Foundation/Foundation.h>

@class JSONSchema;
@class JSONSchemaValidationResult;

@interface JSONSchemaValidationLogic : NSObject


- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchema*)schema context:(id)context;

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchema*)schema;

/**
 @discussion compataibility method
 */
- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)outErrors;

@end
