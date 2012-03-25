//
//  JSONValidationContext.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONValidationContext.h"
#import "JSONSchemaErrors.h"
#import "JSONSchema.h"

@interface JSONValidationContext ()
@property (nonatomic, retain) NSMutableDictionary* schemasByURL;
@end

@implementation JSONValidationContext

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

- (BOOL) validateString:(NSString*)string againstSchema:(JSONSchema*)schema context:(id)context error:(NSArray**)errors
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

- (BOOL) validateNumber:(NSNumber*)number againstSchema:(JSONSchema*)schema context:(id)context error:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if (schema.minimum != nil) {
        if ([schema.minimum compare:number] == NSOrderedDescending) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE, 
                          ([NSString stringWithFormat:@"[%@:%@] expected minimum (%@)", context, number, schema.minimum]))];

        }
    }

    if (schema.maximum != nil) {
        if ([schema.maximum compare:number] == NSOrderedAscending) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE, 
                          ([NSString stringWithFormat:@"[%@:%@] expected maximum (%@)", context, number, schema.minimum]))];
            
        }
    }

    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    
    return [myErrors count] == 0;
}

- (BOOL) validateInteger:(NSNumber*)number againstSchema:(JSONSchema*)schema context:(id)context error:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    // Test if number is integral
    if (![number isEqualToNumber:[NSNumber numberWithInteger:[number integerValue]]]) {
        
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


- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema context:(id)context errors:(NSArray**)outErrors
{
    //    NSMutableArray* allErrors = [NSMutableArray array];
    BOOL foundValidType = NO;
    NSArray* errors = nil;
    
    for (NSString* type in schema.types) {
        
        if ([type isEqualToString:JSONSchemaTypeString]
            && [object isKindOfClass:[NSString class]]) {
            
            if ([self validateString:(NSString*)object againstSchema:schema context:context error:&errors]) {
                foundValidType = YES;
            }
            break;
        }
        
        else if ([type isEqualToString:JSONSchemaTypeNumber]
                 && [object isKindOfClass:[NSNumber class]]) {
            
            if ([self validateNumber:(NSNumber*)object againstSchema:schema context:context error:&errors]) {
                foundValidType = YES;
            }
            break;
        }
        
        else if ([type isEqualToString:JSONSchemaTypeInteger]
                 && [object isKindOfClass:[NSNumber class]]) {
            
            if ([self validateInteger:(NSNumber*)object againstSchema:schema context:context error:&errors]) {
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
