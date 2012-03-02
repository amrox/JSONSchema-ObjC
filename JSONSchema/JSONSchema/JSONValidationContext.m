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

- (BOOL) validateString:(id)obj againstSchema:(JSONSchema*)schema error:(NSArray**)errors
{
    NSMutableArray* myErrors = [NSMutableArray array];
    
    if (![obj isKindOfClass:[NSString class]]) {
        [myErrors addObject:
         JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE, 
                      ([NSString stringWithFormat:@"[%@] expected type (string)", obj]))];
    }
    
    NSString* string = (NSString*)obj;
    
    if (schema.minLength != nil) {
        if ([string length] < [schema.minLength integerValue]) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE, 
                          ([NSString stringWithFormat:@"[%@] expected minLength (%d)", obj, [schema.minLength integerValue]]))];
        }
    }
    
    if (schema.maxLength != nil) {
        if ([string length] > [schema.maxLength integerValue]) {
            [myErrors addObject:
             JSERR_REASON(JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE, 
                          ([NSString stringWithFormat:@"[%@] expected maxLength (%d)", obj, [schema.maxLength integerValue]]))];
        }
    }
    
    if ([myErrors count] > 0 && errors != nil) {
        *errors = myErrors;
    }
    
    return [myErrors count] == 0;
}

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)errors
{
    NSMutableArray* allErrors = [NSMutableArray array];

    if ([object isKindOfClass:[NSString class]]) {
        
        if ([schema.types containsObject:JSONSchemaTypeString]) {
            NSArray* errors = nil;
            if (![self validateString:object againstSchema:schema error:&errors]) {
                [allErrors addObjectsFromArray:errors];
                return NO;
            }
        } else {
            // TODO: error
            return NO;
        }
        
    } else if ([object isKindOfClass:[NSNumber class]]) {

        if ([schema.types containsObject:JSONSchemaTypeNumber]) {
            return NO;

        } else {
            // TODO: error
            return NO;
        }
    }
    
    return YES;
}


@end
