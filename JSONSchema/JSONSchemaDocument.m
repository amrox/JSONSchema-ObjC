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
#import <objc/runtime.h>
#import "JSONSchemaDictionaryRepresentation.h"

NSString* const JSONSchemaAttributeId                = @"id";
NSString* const JSONSchemaAttributeTitle             = @"title";
NSString* const JSONSchemaAttributeType              = @"type";
NSString* const JSONSchemaAttributeMinimum           = @"minimum";
NSString* const JSONSchemaAttributeMaximum           = @"maximum";
NSString* const JSONSchemaAttributeExclusiveMinimum  = @"exclusiveMaximum";
NSString* const JSONSchemaAttributeExclusiveMaximum  = @"exclusiveMaximum";

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
    if ([self class] == [JSONSchemaDocument class]) {
        return [[[JSONSchema defaultSchemaDocumentClass] schema] tap:block];
    } else {
        return [[self schema] tap:block];
    }
}

+ (NSInteger) version
{
    AssertMustOverride();
    return -1;
}

+ (NSArray*) allAttributes
{
    __strong static NSMutableArray* allAttributes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        allAttributes = [NSMutableArray array];
        unsigned int propertyCount = 0;
        objc_property_t* properties = class_copyPropertyList(self, &propertyCount);

        for( int i=0; i<propertyCount; i++ ) {
            objc_property_t property = properties[i];
            NSString* propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];

            NSString* attributeName = [self attributeNameForPropertyName:propertyName];

            [allAttributes addObject:attributeName];
        }
        
        free(properties);
    });

    return allAttributes;
}

- (NSString*) jsonSchema_dictionaryKeyForPropertyName:(NSString*)propertyName
{
    return [[self class] attributeNameForPropertyName:propertyName];
}

- (NSDictionary*) dictionaryRepresentation
{
    return [self jsonSchema_dictionaryRepresentation];
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
    __strong static NSMutableDictionary* d = nil;
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
    AssertMustOverride();
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

+ (NSSet*) validTypes
{
    return [NSSet setWithObjects:
            JSONSchemaTypeObject,
            JSONSchemaTypeString,
            JSONSchemaTypeNumber,
            JSONSchemaTypeInteger,
            JSONSchemaTypeBoolean,
            JSONSchemaTypeArray,
            JSONSchemaTypeNull,
            JSONSchemaTypeAny,
            nil];
}

- (BOOL) validateId:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSString class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (string) for attribute 'id'");
        return NO;
    }
    return YES;
}

- (BOOL) validateTitle:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSString class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (string) for attribute 'title'");
        return NO;
    }
    return YES;
}

- (BOOL) validateTypeKey:(NSString*)key value:(id*)value error:(NSError**)error
{
    if (*value == nil) {
        return YES;
    }

    if ([*value isKindOfClass:[NSString class]]) {

        if (![[[self class] validTypes] containsObject:*value]) {
            JSERR_REASON_P(error, JSONSCHEMA_ERROR_INVALID_TYPE,
                           ([NSString stringWithFormat:@"invalid type: %@", *value]));
            return NO;
        }

        *value = @[*value];;
        return YES;

    } else if ([*value isKindOfClass:[NSArray class]]) {

        NSArray* types = (NSArray*)*value;
        for (id type in types) {
            if (![[[self class] validTypes] containsObject:type]) {
                JSERR_REASON_P(error, JSONSCHEMA_ERROR_INVALID_TYPE,
                               ([NSString stringWithFormat:@"invalid type: %@", type]));
                return NO;
            }
        }
        return YES;
    }

    JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                   ([NSString stringWithFormat:@"expected type (string,array) for attribute '%@'", key]));
    return NO;
}

- (BOOL) validateTypes:(id*)value error:(NSError**)error
{
    return [self validateTypeKey:@"types" value:value error:error];
}

#pragma mark -

- (NSString*) description
{
    return [[self dictionaryRepresentation] description];
}

@end
