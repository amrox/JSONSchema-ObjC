//
//  JSONSchemaObject.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import "JSONSchemaDocument.h"
#import "JSONschema.h"
#import "JSONSchemaInternal.h"
#import "JSONSchemaValidationResult.h"


NSString* const JSONSchemaTypeObject                 = @"object";
NSString* const JSONSchemaTypeString                 = @"string";
NSString* const JSONSchemaTypeNumber                 = @"number";
NSString* const JSONSchemaTypeInteger                = @"integer";
NSString* const JSONSchemaTypeBoolean                = @"boolean";
NSString* const JSONSchemaTypeArray                  = @"array";
NSString* const JSONSchemaTypeNull                   = @"null";
NSString* const JSONSchemaTypeAny                    = @"any";


@implementation JSONSchemaDocument

+ (id) schema
{
    return [[self alloc] init];
}

+ (id) JSONSchemaWithObject:(id)obj error:(NSError**)error
{
    Class cls = [JSONSchema defaultSchemaDocumentClass];

    return [cls JSONSchemaWithObject:obj error:error];
}

+ (NSInteger) version
{
    AssertNYI();
    return -1;
}


#pragma mark Internal Validation

- (BOOL) validateAndSetKey:(NSString*)key fromObject:(id)object objectKey:(NSString*)objectKey error:(NSError**)outError
{
    id value = [object valueForKey:objectKey];
    if (![self validateValue:&value forKey:key error:outError]) {
        return NO;
    }
    [self setValue:value forKey:key];

    return YES;
}

- (BOOL) validateAndSetKey:(NSString*)key fromObject:(id)object error:(NSError**)outError
{
    return [self validateAndSetKey:key fromObject:object objectKey:key error:outError];
}


#pragma mark Validation

- (JSONSchemaValidationResult*) validate:(id)object context:(id)context
{
    NSAssert(NO, @"Subclasses must override this method");
    return nil;
}

- (JSONSchemaValidationResult*) validate:(id)object
{
    return [self validate:object context:nil];
}

- (BOOL) validate:(id)object errors:(NSArray**)outErrors
{
    JSONSchemaValidationResult* result = [self validate:object];

    if (outErrors != NULL) {
        *outErrors = result.errors;
    }

    return [result isValid];
}

@end
