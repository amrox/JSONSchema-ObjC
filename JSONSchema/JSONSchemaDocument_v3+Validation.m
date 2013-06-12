//
//  JSONSchemaDraft3ValidationLogic.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/19/13.
//
//

#import "JSONSchemaDocument_v3.h"

#import "JSONSchemaErrors.h"
#import "JSONSchemaDocument_v3.h"
#import "NSNumber+JSONSchema.h"
#import "JSONSchemaValidationResult+Private.h"


@interface JSONSchemaDocument_v3 (Validation)
@end


@implementation JSONSchemaDocument_v3 (Validation)

- (JSONSchemaValidationResult*) validateString:(NSString*)string againstSchema:(JSONSchemaDocument_v3*)schema context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (schema.minLength != nil) {
        if ([string length] < [schema.minLength integerValue]) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected minLength (%d)", context, string, [schema.minLength integerValue]]))];
        }
    }

    if (schema.maxLength != nil) {
        if ([string length] > [schema.maxLength integerValue]) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected maxLength (%d)", context, string, [schema.maxLength integerValue]]))];
        }
    }

    if (schema.pattern != nil) {
        NSError* regexError = nil;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:schema.pattern
                                                                               options:0
                                                                                 error:&regexError];
        if (regex == nil) {
            [result addError:regexError];
        } else {
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                                                options:0
                                                                  range:NSMakeRange(0, string.length)];
            if (numberOfMatches == 0) {
                [result addError:

                 JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] does not match regular expression '%@'", context, string, schema.pattern]))];
            }
        }
    }

    if (schema.possibleValues != nil) {

        if (![schema.possibleValues containsObject:string]) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] possible values (%@)", context, string, schema.possibleValues]))];

        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateNumber:(NSNumber*)number againstSchema:(JSONSchemaDocument_v3*)schema context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (schema.minimum != nil) {
        if ([schema.minimum compare:number] == NSOrderedDescending) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected minimum (%@)", context, number, schema.minimum]))];
        }
    }

    if (schema.exclusiveMinimum != nil) {
        if ([schema.exclusiveMinimum compare:number] != NSOrderedAscending) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected exclusiveMinimum (%@)", context, number, schema.exclusiveMinimum]))];
        }
    }

    if (schema.maximum != nil) {
        if ([schema.maximum compare:number] == NSOrderedAscending) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected maximum (%@)", context, number, schema.maximum]))];
        }
    }

    if (schema.exclusiveMaximum != nil) {
        if ([schema.exclusiveMaximum compare:number] != NSOrderedDescending) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected exclusiveMaximum (%@)", context, number, schema.exclusiveMaximum]))];
        }
    }

    if (schema.divisibleBy != nil) {
        // first make sure the number is integral
        if (![number jsonSchema_isIntegral]) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not integer", context, number]))];
        } else {
            NSInteger remainder = [number integerValue] % [schema.divisibleBy integerValue];
            if (remainder != 0) {
                [result addError:
                 JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] expected divisibleBy (%@)", context, number, schema.divisibleBy]))];
            }
        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateTypeInteger:(id)object context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (![object isKindOfClass:[NSNumber class]]) {

        [result addError:
         JSERR_REASON(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not a number", context, object]))];

    } else {

        NSNumber* number = (NSNumber*)object;

        // Test if number is integral
        if (![number jsonSchema_isIntegral]) {

            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not integer", context, number]))];
        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateTypeBoolean:(id)object context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (![object isKindOfClass:[NSNumber class]]) {

        [result addError:
         JSERR_REASON(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not a number", context, object]))];

    } else {

        NSNumber* number = (NSNumber*)object;

        // Test if number is boolean
        if (!([number isEqualToNumber:@YES]
              || [number isEqualToNumber:@NO])) {

            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not boolean", context, number]))];
        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateTypeObject:(id)object context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (![object isKindOfClass:[NSDictionary class]]) {

        [result addError:
         JSERR_REASON(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not an object", context, object]))];

    }

    return result;
}

- (JSONSchemaValidationResult*) validateTypeArray:(id)object context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (![object isKindOfClass:[NSArray class]]) {

        [result addError:
         JSERR_REASON(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not an array", context, object]))];

    }

    return result;
}

- (JSONSchemaValidationResult*) validateArray:(NSArray*)array againstSchema:(JSONSchemaDocument_v3*)schema context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (schema.minItems != nil) {
        if ([array count] < [schema.minItems unsignedIntegerValue]) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%d] expected minItems (%@)", context, [array count], schema.minItems]))];
        }
    }

    if (schema.maxItems != nil) {
        if ([array count] > [schema.maxItems unsignedIntegerValue]) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%d] expected maxItems (%@)", context, [array count], schema.maxItems]))];
        }
    }

    if (schema.uniqueItems) {
        NSUInteger c = [array count];
        for (NSUInteger i = 0; i < c - 1; i++) {
            for (NSUInteger j = i + 1; j < c; j++) {
                id obj1 = array[i];
                id obj2 = array[j];
                if (![obj1 respondsToSelector:@selector(isEqual:)]) {
                    [result addError:
                     JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@:%@] does not respond to isEqual:", context, obj1]))];
                } else if (![obj2 respondsToSelector:@selector(isEqual:)]) {
                    [result addError:
                     JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@:%@] does not respond to isEqual:", context, obj2]))];
                } else if ([obj1 isEqual:obj2]) {
                    [result addError:
                     JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@] %@ is equal to %@", context, obj1, obj2]))];
                }
            }
        }
    }

    if (schema.possibleValues != nil) {
        for (id obj in array) {
            if (![schema.possibleValues containsObject:obj]) {
                [result addError:
                 JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] is not in enum: %@", context, obj, schema.possibleValues]))];
            }
        }
    }

    // TODO: finish
    if (schema.items != nil) {
        if ([schema.items isKindOfClass:[JSONSchemaDocument_v3 class]]) {

            JSONSchemaDocument_v3* itemSchema = (JSONSchemaDocument_v3*)schema.items;

            for (id item in array) {
                [result addErrorsFromResult:
                 [self validate:item againstSchema:itemSchema context:context]];
            }


        } else if ([schema.items isKindOfClass:[NSArray class]]) {
            abort();

        } else {
            abort();
        }

        if (schema.additionalItems != nil) {
            if ([schema.items isKindOfClass:[JSONSchemaDocument_v3 class]]) {
                abort();

            } else if ([schema.additionalItems isKindOfClass:[NSNumber class]]) {
                abort();

            } else {
                abort();
            }
        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateProperty:(NSString*)property ofDictObject:(NSDictionary*)dict againstSchema:(JSONSchemaDocument_v3*)schema context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    id val = dict[property];

    if (schema.required) {
        if (val == nil) {
            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_MISSING_VALUE,
                          ([NSString stringWithFormat:@"[%@] required property '%@' is missing.", context, property]))];

        }
    }

    if (val != nil) {
        [result addErrorsFromResult:
         [self validate:val againstSchema:schema context:context]];
    }

    return result;
}

- (JSONSchemaValidationResult*) validateDictObject:(NSDictionary*)dict againstSchema:(JSONSchemaDocument_v3*)schema context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (schema.properties != nil) {
        [schema.properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString* propertyName = key;
            JSONSchemaDocument_v3* propertySchema = obj;
            [result addErrorsFromResult:
             [self validateProperty:propertyName ofDictObject:dict againstSchema:propertySchema context:context]];
        }];
    }

    return result;
}

- (BOOL) validateObject:(id)object matchesTypes:(NSArray*)types context:(id)context;
{
    BOOL foundValidType = NO;
    JSONSchemaValidationResult* result = nil;

    for (NSString* type in types) {

        if ([type isEqualToString:JSONSchemaTypeString]
            && [object isKindOfClass:[NSString class]]) {

            foundValidType = YES;
            break;
        }

        else if ([type isEqualToString:JSONSchemaTypeNumber]
                 && [object isKindOfClass:[NSNumber class]]) {

            foundValidType = YES;
            break;
        }

        else if ([type isEqualToString:JSONSchemaTypeInteger]) {

            result = [self validateTypeInteger:object context:context];
            break;
        }

        else if ([type isEqualToString:JSONSchemaTypeBoolean]) {

            result = [self validateTypeBoolean:object context:context];
            break;
        }

        else if ([type isEqualToString:JSONSchemaTypeArray]) {

            result = [self validateTypeArray:object context:context];
            break;
        }

        else if ([type isEqualToString:JSONSchemaTypeObject]) {

            result = [self validateTypeObject:object context:context];
            break;
        }

        else if ([type isEqualToString:JSONSchemaTypeNull]
                 && [object isKindOfClass:[NSNull class]]) {

            foundValidType = YES;
            break;
        }
    }

    if (result != nil) {
        foundValidType = [result isValid];
    }

    return foundValidType;
}

- (JSONSchemaValidationResult*) validateObjectByType:(id)object againstSchema:(JSONSchemaDocument_v3*)schema context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if ([object isKindOfClass:[NSString class]]) {
        [result addErrorsFromResult:
         [self validateString:(NSString*)object againstSchema:schema context:context]];
    }

    else if ([object isKindOfClass:[NSNumber class]]) {

        [result addErrorsFromResult:
         [self validateNumber:(NSNumber*)object againstSchema:schema context:context]];

        if ([schema.types containsObject:JSONSchemaTypeBoolean]) {
            [result addErrorsFromResult:
             [self validateTypeBoolean:(NSNumber*)object context:context]];
        }

        if ([schema.types containsObject:JSONSchemaTypeInteger]) {
            [result addErrorsFromResult:
             [self validateTypeInteger:(NSNumber*)object context:context]];
        }

    }

    else if ([object isKindOfClass:[NSArray class]]) {
        [result addErrorsFromResult:
         [self validateArray:(NSArray*)object againstSchema:schema context:context]];
    }

    else if ([object isKindOfClass:[NSDictionary class]]) {
        [result addErrorsFromResult:
         [self validateDictObject:(NSDictionary*)object againstSchema:schema context:context]];
    }

    return result;
}

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchemaDocument_v3*)schema context:(id)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (schema.types != nil) {

        BOOL match = [self validateObject:object matchesTypes:schema.types context:context];

        if (!match) {

            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE,
                          ([NSString stringWithFormat:@"[%@:%@] allowed types (%@)",
                            object, context,
                            [schema.types componentsJoinedByString:@","]]))];
        }
    }

    if (schema.disallowedTypes != nil) {

        BOOL match = [self validateObject:object matchesTypes:schema.disallowedTypes context:context];

        if (match) {

            [result addError:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE,
                          ([NSString stringWithFormat:@"[%@:%@] disallowed types (%@)",
                            object, context,
                            [schema.types componentsJoinedByString:@","]]))];
        }
    }

    [result addErrorsFromResult:
     [self validateObjectByType:object againstSchema:schema context:context]];

    return result;
}

- (JSONSchemaValidationResult*) validate:(id)object context:(id)context
{
    return [self validate:object againstSchema:self context:context];
}

@end
