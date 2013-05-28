//
//  JSONSchemaDraft4.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import "JSONSchemaDocument_v4.h"
#import "JSONSchemaInternal.h"
#import "JSONSchemaDocument+Private.h"


NSString* const JSONSchemaAttributeMultipleOf           = @"multipleOf";


@implementation JSONSchemaDocument_v4

+ (NSInteger) version
{
    return 4;
}


+ (id) JSONSchemaWithObject:(id)obj error:(NSError**)error
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    if (![schema validateAndSetAttribute:JSONSchemaAttributeMultipleOf fromObject:obj error:error]) return nil;

    return schema;
}


#pragma mark Validation Methods

- (BOOL) validateMultipleOf:(id*)value error:(NSError**)error
{
    if (*value != nil) {

        if (![*value isKindOfClass:[NSNumber class]]) {
            JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                           @"expected type (number) for attribute 'multipleOf'");
            return NO;
        }

        if ([*value doubleValue] <= 0) {
            JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_VALUE,
                           @"expected (value > 0) for attribute 'multipleOf'");
            return NO;
        }
    }
    return YES;
}

@end
