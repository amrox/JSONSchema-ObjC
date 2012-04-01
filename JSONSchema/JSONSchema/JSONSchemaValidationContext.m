//
//  JSONValidationContext.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaValidationContext.h"
#import "JSONSchemaErrors.h"
#import "JSONSchema.h"
#import "NSNumber+JSONSchema.h"

@interface JSONSchemaValidationContext ()
@property (nonatomic, retain) NSMutableDictionary* schemasByURL;
@end

@implementation JSONSchemaValidationContext

@synthesize schemasByURL = _schemasByURL;

- (id)init
{
    self = [super init];
    if (self) {
        _schemasByURL = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_schemasByURL release];
    [super dealloc];
}

- (void) addSchema:(JSONSchema*)schema forURL:(NSURL*)url
{
    [self.schemasByURL setObject:schema forKey:url];
}

+ (BOOL) validateString:(NSString*)string againstSchema:(JSONSchema*)schema context:(id)context error:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    //    if (![obj isKindOfClass:[NSString class]]) {
    //        [myErrors addObject:
    //         JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE, 
    //                      ([NSString stringWithFormat:@"[%@] expected type (string)", obj]))];
    //        return NO;
    //    }
    //    
    //    NSString* string = (NSString*)obj;
    
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
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    
    return [myErrors count] == 0;
}

+ (BOOL) validateNumber:(NSNumber*)number againstSchema:(JSONSchema*)schema context:(id)context error:(NSArray**)errors
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

+ (BOOL) validateInteger:(NSNumber*)number againstSchema:(JSONSchema*)schema context:(id)context error:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
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

    return [self validateNumber:number againstSchema:schema context:context error:errors];
}

+ (BOOL) validateBoolean:(NSNumber*)number againstSchema:(JSONSchema*)schema context:(id)context error:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    // Test if number is boolean
    if (!([number isEqualToNumber:[NSNumber numberWithBool:YES]]
          || [number isEqualToNumber:[NSNumber numberWithBool:NO]])) {
        
        [myErrors addObject:
         JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE, 
                      ([NSString stringWithFormat:@"[%@:%@] not integer", context, number]))];
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    
    return [myErrors count] == 0;
}

+ (BOOL) validateArray:(NSArray*)array againstSchema:(JSONSchema*)schema context:(id)context error:(NSArray**)errors
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

    return [myErrors count] == 0;
}

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)outErrors
{
    BOOL foundValidType = NO;
    NSArray* errors = nil;
    
    for (NSString* type in schema.types) {
        
        if ([type isEqualToString:JSONSchemaTypeString]
            && [object isKindOfClass:[NSString class]]) {
            
            if ([[self class] validateString:(NSString*)object againstSchema:schema context:context error:&errors]) {
                foundValidType = YES;
            }
            break;
        }
        
        else if ([type isEqualToString:JSONSchemaTypeNumber]
                 && [object isKindOfClass:[NSNumber class]]) {
            
            if ([[self class] validateNumber:(NSNumber*)object againstSchema:schema context:context error:&errors]) {
                foundValidType = YES;
            }
            break;
        }
        
        else if ([type isEqualToString:JSONSchemaTypeInteger]
                 && [object isKindOfClass:[NSNumber class]]) {
            
            if ([[self class] validateInteger:(NSNumber*)object againstSchema:schema context:context error:&errors]) {
                foundValidType = YES;
            }
            break;
        }

        else if ([type isEqualToString:JSONSchemaTypeBoolean]
                 && [object isKindOfClass:[NSNumber class]]) {
            
            if ([[self class] validateBoolean:(NSNumber*)object againstSchema:schema context:context error:&errors]) {
                foundValidType = YES;
            }
            break;
        }
        
        else if ([type isEqualToString:JSONSchemaTypeArray]
                 && [object isKindOfClass:[NSArray class]]) {
            
            if ([[self class] validateArray:(NSArray*)object againstSchema:schema context:context error:&errors]) {
                foundValidType = YES;
            }
            break;
        }

    }
    
    if (([errors count] > 0) && (outErrors != NULL)) {
        *outErrors = errors;
        return NO;
    }
    
    if (!foundValidType) {
        
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

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)errors;
{
    return [self validate:object againstSchema:schema context:nil errors:errors];
}


@end
