//
//  JSONSchemaValidationRules.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 12/29/12.
//
//

#import "JSONSchemaValidationLogic.h"
#import "JSONSchemaErrors.h"
#import "JSONSchema.h"
#import "NSNumber+JSONSchema.h"

@implementation JSONSchemaValidationLogic

+ (JSONSchemaValidationLogic*) defaultValidationLogic
{
    static dispatch_once_t onceToken;
    static JSONSchemaValidationLogic* defaultInstance = nil;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[JSONSchemaValidationLogic alloc] init];
    });
    return defaultInstance;
}

- (BOOL) validateString:(NSString*)string againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if (schema.minLength != nil) {
        if ([string length] < [schema.minLength integerValue]) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected minLength (%d)", context, string, [schema.minLength integerValue]]))];
        }
    }
    
    if (schema.maxLength != nil) {
        if ([string length] > [schema.maxLength integerValue]) {
            [myErrors addObject:
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
            [myErrors addObject:regexError];
        } else {
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                                                options:0
                                                                  range:NSMakeRange(0, string.length)];
            if (numberOfMatches == 0) {
                [myErrors addObject:
                 
                 JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] does not match regular expression '%@'", context, string, schema.pattern]))];
            }
        }
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    return [myErrors count] == 0;
}

- (BOOL) validateNumber:(NSNumber*)number againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if (schema.minimum != nil) {
        if ([schema.minimum compare:number] == NSOrderedDescending) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected minimum (%@)", context, number, schema.minimum]))];
        }
    }
    
    if (schema.exclusiveMinimum != nil) {
        if ([schema.exclusiveMinimum compare:number] != NSOrderedAscending) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected excluseMinimum (%@)", context, number, schema.exclusiveMinimum]))];
        }
    }
    
    if (schema.maximum != nil) {
        if ([schema.maximum compare:number] == NSOrderedAscending) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected maximum (%@)", context, number, schema.minimum]))];
        }
    }
    
    if (schema.exclusiveMaximum != nil) {
        if ([schema.exclusiveMaximum compare:number] != NSOrderedDescending) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] expected excluseMaximum (%@)", context, number, schema.minimum]))];
        }
    }
    
    if (schema.divisibleBy != nil) {
        // first make sure the number is integral
        if (![number jsonSchema_isIntegral]) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not integer", context, number]))];
        } else {
            NSInteger remainder = [number integerValue] % [schema.divisibleBy integerValue];
            if (remainder != 0) {
                [myErrors addObject:
                 JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] expected divisibleBy (%@)", context, number, schema.divisibleBy]))];
            }
        }
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    return [myErrors count] == 0;
}

- (BOOL) validateTypeInteger:(id)object context:(id)context errors:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        
        [myErrors addObject:
         JSERR_REASON(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not a number", context, object]))];
        
    } else {
        
        NSNumber* number = (NSNumber*)object;
        
        // Test if number is integral
        if (![number jsonSchema_isIntegral]) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not integer", context, number]))];
            if (errors != NULL) {
                *errors = myErrors;
            }
            return NO;
        }
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    return [myErrors count] == 0;
}

- (BOOL) validateTypeBoolean:(id)object context:(id)context errors:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        
        [myErrors addObject:
         JSERR_REASON(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not a number", context, object]))];
        
    } else {
        
        NSNumber* number = (NSNumber*)object;
        
        // Test if number is boolean
        if (!([number isEqualToNumber:[NSNumber numberWithBool:YES]]
              || [number isEqualToNumber:[NSNumber numberWithBool:NO]])) {
            
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%@] not boolean", context, number]))];
        }
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    
    return [myErrors count] == 0;
}

- (BOOL) validateTypeArray:(id)object context:(id)context errors:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if (![object isKindOfClass:[NSArray class]]) {
        
        [myErrors addObject:
         JSERR_REASON(JSONSCHEMA_ERROR_INVALID_TYPE,
                      ([NSString stringWithFormat:@"[%@:%@] not an array", context, object]))];
        
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    return [myErrors count] == 0;
}

- (BOOL) validateArray:(NSArray*)array againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if (schema.minItems != nil) {
        if ([array count] < [schema.minItems unsignedIntegerValue]) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%d] expected minItems (%@)", context, [array count], schema.minItems]))];
        }
    }
    
    if (schema.maxItems != nil) {
        if ([array count] > [schema.maxItems unsignedIntegerValue]) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                          ([NSString stringWithFormat:@"[%@:%d] expected maxItems (%@)", context, [array count], schema.maxItems]))];
        }
    }
    
    if (schema.uniqueItems) {
        NSUInteger c = [array count];
        for (NSUInteger i = 0; i < c - 1; i++) {
            for (NSUInteger j = i + 1; j < c; j++) {
                id obj1 = [array objectAtIndex:i];
                id obj2 = [array objectAtIndex:j];
                if (![obj1 respondsToSelector:@selector(isEqual:)]) {
                    [myErrors addObject:
                     JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@:%@] does not respond to isEqual:", context, obj1]))];
                } else if (![obj2 respondsToSelector:@selector(isEqual:)]) {
                    [myErrors addObject:
                     JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@:%@] does not respond to isEqual:", context, obj2]))];
                } else if ([obj1 isEqual:obj2]) {
                    [myErrors addObject:
                     JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                                  ([NSString stringWithFormat:@"[%@] %@ is equal to %@", context, obj1, obj2]))];
                }
            }
        }
    }
    
    if (schema.possibleValues != nil) {
        for (id obj in array) {
            if (![schema.possibleValues containsObject:obj]) {
                [myErrors addObject:
                 JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE,
                              ([NSString stringWithFormat:@"[%@:%@] is not in enum: %@", context, obj, schema.possibleValues]))];
            }
        }
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    return [myErrors count] == 0;
}

- (BOOL) validateProperty:(NSString*)property ofDictObject:(NSDictionary*)dict againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    id val = [dict objectForKey:property];
    
    if (schema.required) {
        if (val == nil) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_MISSING_VALUE,
                          ([NSString stringWithFormat:@"[%@] required property '%@' is missing.", context, property]))];
            
        }
    }
    
    if (val != nil) {
        [self validate:val againstSchema:schema context:context errors:errors];
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    return [myErrors count] == 0;
}

- (BOOL) validateDictObject:(NSDictionary*)dict againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)outErrors
{
    __block NSMutableArray* myErrors = [NSMutableArray array];
    
    if (schema.properties != nil) {
        [schema.properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString* propertyName = key;
            JSONSchema* propertySchema = obj;
            [self validateProperty:propertyName ofDictObject:dict againstSchema:propertySchema context:context errors:&myErrors];
        }];
    }
    
    if ([myErrors count] > 0 && outErrors != NULL) {
        *outErrors = myErrors;
    }
    return [myErrors count] == 0;
}

- (BOOL) validateObject:(id)object matchesTypes:(NSArray*)types context:(id)context errors:(NSArray**)outErrors
{
    BOOL foundValidType = NO;
    NSMutableArray* myErrors = [NSMutableArray array];
    
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
            
            if ([self validateTypeInteger:object context:context errors:&myErrors]) {
                foundValidType = YES;
            }
            break;
        }
        
        else if ([type isEqualToString:JSONSchemaTypeBoolean]) {
            
            if ([self validateTypeBoolean:object context:context errors:&myErrors]) {
                foundValidType = YES;
            }
            break;
        }
        
        else if ([type isEqualToString:JSONSchemaTypeArray]) {
            
            if ([self validateTypeArray:object context:context errors:&myErrors]) {
                foundValidType = YES;
            }
            break;
        }
    }
    
    if (([myErrors count] > 0) && (outErrors != NULL)) {
        *outErrors = myErrors;
        return NO;
    }
    
    if (!foundValidType) {
        
        if (outErrors != NULL) {
            *outErrors = [NSArray arrayWithObject:
                          JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE,
                                       ([NSString stringWithFormat:@"[%@:%@] expected types (%@)",
                                         object, context,
                                         [types componentsJoinedByString:@","]]))];
        }
        return NO;
    }
    return YES;
}

- (BOOL) validateObjectByType:(id)object againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)outErrors
{
    BOOL valid = YES;
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if ([object isKindOfClass:[NSString class]]) {
        valid &= [self validateString:(NSString*)object againstSchema:schema context:context errors:&myErrors];
    }
    
    else if ([object isKindOfClass:[NSNumber class]]) {
        
        valid &= [self validateNumber:(NSNumber*)object againstSchema:schema context:context errors:&myErrors];
        
        if ([schema.types containsObject:JSONSchemaTypeBoolean]) {
            valid &= [self validateTypeBoolean:(NSNumber*)object context:context errors:&myErrors];
        }
        
        if ([schema.types containsObject:JSONSchemaTypeInteger]) {
            valid &= [self validateTypeInteger:(NSNumber*)object context:context errors:&myErrors];
        }
        
    }
    
    else if ([object isKindOfClass:[NSArray class]]) {
        valid &= [self validateArray:(NSArray*)object againstSchema:schema context:context errors:&myErrors];
    }
    
    else if ([object isKindOfClass:[NSDictionary class]]) {
        valid &= [self validateDictObject:(NSDictionary*)object againstSchema:schema context:context errors:&myErrors];
    }
    
    if (([myErrors count] > 0) && (outErrors != NULL)) {
        *outErrors = myErrors;
        return NO;
    }
    
    if (!valid) {
        
        if (outErrors != NULL) {
            *outErrors = [NSArray arrayWithObject:
                          JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE,
                                       ([NSString stringWithFormat:@"[%@:%@] expected types (%@)",
                                         object, context,
                                         [schema.types componentsJoinedByString:@","]]))];
        }
        return NO;
    }
    return YES;
}

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)outErrors
{
    BOOL valid = YES;
    
    if (schema.types != nil) {
        valid &= [self validateObject:object matchesTypes:schema.types context:context errors:outErrors];
    }
    
    if (schema.disallowedTypes != nil) {
        valid &= ![self validateObject:object matchesTypes:schema.disallowedTypes context:context errors:outErrors];
    }
    
    valid &= [self validateObjectByType:object againstSchema:schema context:context errors:outErrors];
    
    return valid;
}

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)outErrors
{
    return [self validate:object againstSchema:schema context:nil errors:outErrors];
}


@end
