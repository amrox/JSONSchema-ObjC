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


NSString* const JSONSchemaAttributeTitle             = @"title";

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

+ (id)JSONSchemaWithData:(NSData *)data error:(NSError**)error
{
    id obj = [[JSONSchema sharedSerializationHelper] JSONObjectWithData:data error:error];
    if (obj == nil) {
        //JSERR_P(error, JSONSCHEMA_ERROR_PARSE_FAIL);
        return nil;
    }
    return [self JSONSchemaWithObject:obj error:error];
}

- (instancetype) tap:(void (^)(id))block
{
    block(self);
    return self;
}

+ (id) build:(void (^)(id schema))block
{
    return [[[JSONSchema defaultSchemaDocumentClass] schema] tap:block];
}

+ (NSInteger) version
{
    AssertNYI();
    return -1;
}

+ (NSArray*) allAttributes
{
    AssertNYI();
    return nil;
}

- (NSDictionary*) dictionaryRepresentation
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:20];

    for (NSString* attribute in [[self class] allAttributes]) {

        id val = [self valueForAttribute:attribute];
        if (val != nil) {
            dict[attribute] = val;
        }
    }
    return dict;
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

- (BOOL) validateAndSetAttribute:(NSString*)attr fromObject:(id)object error:(NSError**)outError
{
    return [self validateAndSetKey:[[self class] propertyNameForAttributeName:attr] fromObject:object objectKey:attr error:outError];
}

#pragma mark -

+ (NSDictionary*) attributeToPropertyMap
{
    return nil;
}

+ (NSDictionary*) propertyToAttributeMap
{
    static NSMutableDictionary* d = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSDictionary* attrToPropMap = [self attributeToPropertyMap];
        d = [NSMutableDictionary dictionaryWithCapacity:[attrToPropMap count]];

        // reverse the dict
        [attrToPropMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            d[obj] = key;
        }];
    });

    return d;
}

+ (NSString*) propertyNameForAttributeName:(NSString*)attributeName
{
    NSString* mapped = [self attributeToPropertyMap][attributeName];
    if (mapped != nil) {
        return mapped;
    }
    return attributeName;
}

+ (NSString*) attributeNameForPropertyName:(NSString*)propertyName
{
    NSString* mapped = [self propertyToAttributeMap][propertyName];
    if (mapped != nil) {
        return mapped;
    }
    return propertyName;

}
- (id) valueForAttribute:(NSString*)attribute
{
    NSString* key = [[self class] propertyNameForAttributeName:attribute];
    return [self valueForKey:key];
}

#pragma mark Validation Helpers

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


#pragma mark Attribute Validation

- (BOOL) validateTitle:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSString class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (string) for attribute 'title'");
        return NO;
    }
    return YES;
}


#pragma mark -

- (NSString*) description
{
    return [[self dictionaryRepresentation] description];
}

@end
