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

+ (JSONSchemaValidationLogic*) defaultValidationLogic;

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchema*)schema context:(id)context;

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchema*)schema;

/**
 @discussion compataibility method
 */
- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)outErrors;


#pragma mark -


- (JSONSchemaValidationResult*) validateString:(NSString*)string againstSchema:(JSONSchema*)schema context:(id)context;

- (JSONSchemaValidationResult*) validateNumber:(NSNumber*)number againstSchema:(JSONSchema*)schema context:(id)context;

- (JSONSchemaValidationResult*) validateArray:(NSArray*)array againstSchema:(JSONSchema*)schema context:(id)context;

#pragma mark Type validation

//- (JSONSchemaValidationResult*) validateObject:(id)object matchesTypes:(NSArray*)types context:(id)context;

- (JSONSchemaValidationResult*) validateObjectByType:(id)object againstSchema:(JSONSchema*)schema context:(id)context;

- (JSONSchemaValidationResult*) validateTypeBoolean:(id)object context:(id)context;

- (JSONSchemaValidationResult*) validateTypeArray:(id)object context:(id)context;

@end
