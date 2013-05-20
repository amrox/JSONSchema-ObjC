//
//  JSONSchemaValidationRules.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 12/29/12.
//
//

#import "JSONSchemaValidationLogic.h"
#import "JSONSchemaValidationResult+Private.h"

@implementation JSONSchemaValidationLogic

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchema*)schema context:(id)context
{
    NSAssert(NO, @"Subclasses must override this method");
    return nil;
}

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchema*)schema
{
    return [self validate:object againstSchema:schema context:nil];
}

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)outErrors
{
    JSONSchemaValidationResult* result = [self validate:object againstSchema:schema];

    if (outErrors != NULL) {
        *outErrors = result.errors;
    }

    return [result isValid];
}

@end
