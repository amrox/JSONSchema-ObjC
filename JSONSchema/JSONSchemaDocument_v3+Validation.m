//
//  JSONSchemaDraft3ValidationLogic.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/19/13.
//
//

#import "JSONSchemaDocument_v3.h"

#import "JSONSchemaInternal.h"
#import "JSONSchemaErrors.h"
#import "JSONSchemaDocument_v3.h"
#import "NSNumber+JSONSchema.h"
#import "JSONSchemaValidationResult+Private.h"
#import "JSONSchemaObjectContext.h"


@interface JSONSchemaDocument_v3 (Validation)
@end


@implementation JSONSchemaDocument_v3 (Validation)

- (JSONSchemaValidationResult*) validateString:(NSString*)string context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (self.minLength != nil) {
        if ([string length] < [self.minLength integerValue]) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected minLength (%d)", context, string, [self.minLength integerValue]]))];
        }
    }

    if (self.maxLength != nil) {
        if ([string length] > [self.maxLength integerValue]) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected maxLength (%d)", context, string, [self.maxLength integerValue]]))];
        }
    }

    if (self.pattern != nil) {
        NSError* regexError = nil;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:self.pattern
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

                 JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] does not match regular expression '%@'", context, string, self.pattern]))];
            }
        }
    }

    if (self.possibleValues != nil) {

        if (![self.possibleValues containsObject:string]) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] possible values (%@)", context, string, self.possibleValues]))];

        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateNumber:(NSNumber*)number context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (self.minimum != nil) {
        if ([self.minimum compare:number] == NSOrderedDescending) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected minimum (%@)", context, number, self.minimum]))];
        }
    }

    if (self.exclusiveMinimum != nil) {
        if ([self.exclusiveMinimum compare:number] != NSOrderedAscending) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected exclusiveMinimum (%@)", context, number, self.exclusiveMinimum]))];
        }
    }

    if (self.maximum != nil) {
        if ([self.maximum compare:number] == NSOrderedAscending) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected maximum (%@)", context, number, self.maximum]))];
        }
    }

    if (self.exclusiveMaximum != nil) {
        if ([self.exclusiveMaximum compare:number] != NSOrderedDescending) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected exclusiveMaximum (%@)", context, number, self.exclusiveMaximum]))];
        }
    }

    if (self.divisibleBy != nil) {
        // first make sure the number is integral
        if (![number jsonSchema_isIntegral]) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not integer", context, number]))];
        } else {
            NSInteger remainder = [number integerValue] % [self.divisibleBy integerValue];
            if (remainder != 0) {
                [result addError:
                 JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] expected divisibleBy (%@)", context, number, self.divisibleBy]))];
            }
        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateTypeInteger:(id)object context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (![object isKindOfClass:[NSNumber class]]) {

        [result addError:
         JSERR(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not a number", context, object]))];

    } else {

        NSNumber* number = (NSNumber*)object;

        // Test if number is integral
        if (![number jsonSchema_isIntegral]) {

            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not integer", context, number]))];
        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateTypeBoolean:(id)object context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (![object isKindOfClass:[NSNumber class]]) {

        [result addError:
         JSERR(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not a number", context, object]))];

    } else {

        NSNumber* number = (NSNumber*)object;

        // Test if number is boolean
        if (!([number isEqualToNumber:@YES]
              || [number isEqualToNumber:@NO])) {

            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not boolean", context, number]))];
        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateTypeObject:(id)object context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (![object isKindOfClass:[NSDictionary class]]) {

        [result addError:
         JSERR(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not an object", context, object]))];

    }

    return result;
}

- (JSONSchemaValidationResult*) validateTypeArray:(id)object context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (![object isKindOfClass:[NSArray class]]) {

        [result addError:
         JSERR(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not an array", context, object]))];

    }

    return result;
}

- (JSONSchemaValidationResult*) validateArray:(NSArray*)array context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (self.minItems != nil) {
        if ([array count] < [self.minItems unsignedIntegerValue]) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%d] expected minItems (%@)", context, [array count], self.minItems]))];
        }
    }

    if (self.maxItems != nil) {
        if ([array count] > [self.maxItems unsignedIntegerValue]) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%d] expected maxItems (%@)", context, [array count], self.maxItems]))];
        }
    }

    if (self.uniqueItems) {
        NSUInteger c = [array count];
        for (NSUInteger i = 0; i < c - 1; i++) {
            for (NSUInteger j = i + 1; j < c; j++) {
                id obj1 = array[i];
                id obj2 = array[j];
                if (![obj1 respondsToSelector:@selector(isEqual:)]) {
                    [result addError:
                     JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@:%@] does not respond to isEqual:", context, obj1]))];
                } else if (![obj2 respondsToSelector:@selector(isEqual:)]) {
                    [result addError:
                     JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@:%@] does not respond to isEqual:", context, obj2]))];
                } else if ([obj1 isEqual:obj2]) {
                    [result addError:
                     JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@] %@ is equal to %@", context, obj1, obj2]))];
                }
            }
        }
    }

    if (self.possibleValues != nil) {
        for (id obj in array) {
            if (![self.possibleValues containsObject:obj]) {
                [result addError:
                 JSERR(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] is not in enum: %@", context, obj, self.possibleValues]))];
            }
        }
    }

    // TODO: finish
    if (self.items != nil) {
        if ([self.items isKindOfClass:[JSONSchemaDocument_v3 class]]) {

            JSONSchemaDocument_v3* itemSchema = (JSONSchemaDocument_v3*)self.items;

            for (id item in array) {
                [result addErrorsFromResult:
                 [itemSchema validate:item context:context]];
            }


        } else if ([self.items isKindOfClass:[NSArray class]]) {
            AssertNYI();

        } else {
            AssertNYI();
        }

        if (self.additionalItems != nil) {
            if ([self.items isKindOfClass:[JSONSchemaDocument_v3 class]]) {
                AssertNYI();

            } else if ([self.additionalItems isKindOfClass:[NSNumber class]]) {
                AssertNYI();

            } else {
                AssertNYI();
            }
        }
    }

    return result;
}

- (JSONSchemaValidationResult*) validateProperty:(NSString*)property ofDictObject:(NSDictionary*)dict context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    id val = dict[property];

    if (self.required) {
        if (val == nil) {
            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_MISSING_VALUE,
                          ([NSString stringWithFormat:@"[%@] required property '%@' is missing.", context, property]))];

        }
    }

    if (val != nil) {
        [result addErrorsFromResult:
         [self validate:val context:context]];
    }

    return result;
}

- (JSONSchemaValidationResult*) validateDictObject:(NSDictionary*)dict context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (self.properties != nil) {
        [self.properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString* propertyName = key;
            JSONSchemaDocument_v3* propertySchema = obj;
            [result addErrorsFromResult:
             [propertySchema validateProperty:propertyName ofDictObject:dict context:context]];
        }];
    }

    return result;
}

- (BOOL) validateObject:(id)object matchesTypes:(NSArray*)types context:(JSONSchemaObjectContext*)context;
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

- (JSONSchemaValidationResult*) validateObjectByType:(id)object context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if ([object isKindOfClass:[NSString class]]) {
        [result addErrorsFromResult:
         [self validateString:(NSString*)object context:context]];
    }

    else if ([object isKindOfClass:[NSNumber class]]) {

        [result addErrorsFromResult:
         [self validateNumber:(NSNumber*)object context:context]];

        if ([self.types containsObject:JSONSchemaTypeBoolean]) {
            [result addErrorsFromResult:
             [self validateTypeBoolean:(NSNumber*)object context:context]];
        }

        if ([self.types containsObject:JSONSchemaTypeInteger]) {
            [result addErrorsFromResult:
             [self validateTypeInteger:(NSNumber*)object context:context]];
        }

    }

    else if ([object isKindOfClass:[NSArray class]]) {
        [result addErrorsFromResult:
         [self validateArray:(NSArray*)object context:context]];
    }

    else if ([object isKindOfClass:[NSDictionary class]]) {
        [result addErrorsFromResult:
         [self validateDictObject:(NSDictionary*)object context:context]];
    }

    return result;
}

- (JSONSchemaValidationResult*) validate:(id)object context:(JSONSchemaObjectContext*)context
{
    JSONSchemaValidationResult* result = [[JSONSchemaValidationResult alloc] init];

    if (self.types != nil) {

        BOOL match = [self validateObject:object matchesTypes:self.types context:context];

        if (!match) {

            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE,
                          ([NSString stringWithFormat:@"[%@:%@] allowed types (%@)",
                            object, context,
                            [self.types componentsJoinedByString:@","]]))];
        }
    }

    if (self.disallowedTypes != nil) {

        BOOL match = [self validateObject:object matchesTypes:self.disallowedTypes context:context];

        if (match) {

            [result addError:
             JSERR(JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE,
                          ([NSString stringWithFormat:@"[%@:%@] disallowed types (%@)",
                            object, context,
                            [self.types componentsJoinedByString:@","]]))];
        }
    }

    [result addErrorsFromResult:
     [self validateObjectByType:object context:context]];

    [context popContext];

    return result;
}

@end
