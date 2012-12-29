//
//  JSONSchemaValidationRules.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 12/29/12.
//
//

#import <Foundation/Foundation.h>

@class JSONSchema;

@interface JSONSchemaValidationRules : NSObject

+ (JSONSchemaValidationRules*) defaultRules;

- (BOOL) validateString:(NSString*)string againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)errors;

- (BOOL) validateNumber:(NSNumber*)number againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)errors;

- (BOOL) validateArray:(NSArray*)array againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)errors;

#pragma mark Type validation

- (BOOL) validateObject:(id)object matchesTypes:(NSArray*)types context:(id)context errors:(NSArray**)outErrors;

- (BOOL) validateObjectByType:(id)object againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)outErrors;

- (BOOL) validateTypeBoolean:(id)object context:(id)context errors:(NSArray**)errors;

- (BOOL) validateTypeArray:(id)object context:(id)context errors:(NSArray**)errors;


- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)outErrors;

@end
