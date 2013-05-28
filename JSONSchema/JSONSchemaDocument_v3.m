//
//  JSONSchema.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaDocument_v3.h"
#import "JSONSchemaInternal.h"
#import "JSONSchemaDocument+Private.h"

NSString* const JSONSchemaAttributeId                = @"id";
NSString* const JSONSchemaAttributeExtends           = @"extends";
NSString* const JSONSchemaAttributeType              = @"type";
NSString* const JSONSchemaAttributeDisallow          = @"disallow";
NSString* const JSONSchemaAttributeDescription       = @"description";
NSString* const JSONSchemaAttributeFormat            = @"format";
NSString* const JSONSchemaAttributeProperties        = @"properties";
NSString* const JSONSchemaAttributePatternProperties = @"patternProperties";
NSString* const JSONSchemaAttributeItems             = @"items";
NSString* const JSONSchemaAttributeRequired          = @"required";
NSString* const JSONSchemaAttributeDefault           = @"default";
NSString* const JSONSchemaAttributeEnum              = @"enum";
NSString* const JSONSchemaAttributeMinimum           = @"minimum";
NSString* const JSONSchemaAttributeMaximum           = @"maximum";
NSString* const JSONSchemaAttributeExclusiveMinimum  = @"exclusiveMaximum";
NSString* const JSONSchemaAttributeExclusiveMaximum  = @"exclusiveMaximum";
NSString* const JSONSchemaAttributeDivisibleBy       = @"divisibleBy";
NSString* const JSONSchemaAttributeMinItems          = @"minItems";
NSString* const JSONSchemaAttributeMaxItems          = @"maxItems";
NSString* const JSONSchemaAttributeUniqueItems       = @"uniqueItems";
NSString* const JSONSchemaAttributeMinLength         = @"minLength";
NSString* const JSONSchemaAttributeMaxLength         = @"maxLength";
NSString* const JSONSchemaAttributePattern           = @"pattern";

NSString* const JSONSchemaFormatDatetime             = @"date-time";
NSString* const JSONSchemaFormatDate                 = @"date";
NSString* const JSONSchemaFormatTime                 = @"time";
NSString* const JSONSchemaFormatUTCMillisec          = @"utc-millisec";
NSString* const JSONSchemaFormatRegex                = @"regex";
NSString* const JSONSchemaFormatColor                = @"color";
NSString* const JSONSchemaFormatStyle                = @"style";
NSString* const JSONSchemaFormatPhone                = @"phone";
NSString* const JSONSchemaFormatURI                  = @"uri";
NSString* const JSONSchemaFormatEmail                = @"email";
NSString* const JSONSchemaFormatIPAddress            = @"ip-address";
NSString* const JSONSchemaFormatIPV6Address          = @"ipv6";
NSString* const JSONSchemaFormatHostname             = @"host-name";

@implementation JSONSchemaDocument_v3

+ (NSInteger) version
{
    return 3;
}

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

+ (NSDictionary*) propertyToAttributeMap
{
    static NSDictionary* d = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        d = @{
              NSStringFromSelector(@selector(types)) : JSONSchemaAttributeType,
              NSStringFromSelector(@selector(disallowedTypes)) : JSONSchemaAttributeDisallow,
              NSStringFromSelector(@selector(defaultValue)) : JSONSchemaAttributeDefault,
              NSStringFromSelector(@selector(possibleValues)) : JSONSchemaAttributeEnum,
              NSStringFromSelector(@selector(descr)) : JSONSchemaAttributeDescription,
              };
    });

    return d;
}



+ (NSDictionary*) attributeToPropertyMap
{
    __strong static NSDictionary* d = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        d = @{
              JSONSchemaAttributeType : NSStringFromSelector(@selector(types)),
              JSONSchemaAttributeDisallow : NSStringFromSelector(@selector(disallowedTypes)),
              JSONSchemaAttributeDefault : NSStringFromSelector(@selector(defaultValue)),
              JSONSchemaAttributeEnum : NSStringFromSelector(@selector(possibleValues)),
              JSONSchemaAttributeDescription : NSStringFromSelector(@selector(descr)),
              };
    });

    return d;
}

+ (NSString*) attributeNameForPropertyName:(NSString*)propertyName
{
    NSString* mapped = [self propertyToAttributeMap][propertyName];
    if (mapped != nil) {
        return mapped;
    }
    return propertyName;

}

- (BOOL) addPropertiesFromDict:(NSDictionary*)dict toKey:(NSString*)key error:(NSError**)error
{
    NSArray* allPropertyNames = [dict allKeys];
    NSMutableDictionary* properties = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
    [self setValue:properties forKey:key];
    
    for (NSString* propertyName in allPropertyNames) {

        id value = dict[propertyName];

        if ([value isKindOfClass:[NSDictionary class]]) {

            JSONSchemaDocument_v3* propertySchema = [[self class] JSONSchemaWithObject:value error:error];
            if (propertySchema == nil) {
                return NO;
            }
            properties[propertyName] = propertySchema;

        } else {
            // TODO: WARNING, didn't find an object. Probably found a URL.
        }
    }
    return YES;
}

- (BOOL) setSchemasFromDictOrArray:(id)dictOrArray toKey:(NSString*)key error:(NSError**)error
{
    if ([dictOrArray isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = dictOrArray;
        JSONSchemaDocument_v3* schema = [[self class] JSONSchemaWithObject:dict error:error];
        if (schema == nil) {
            return NO;
        }
        [self setValue:schema forKey:key];
    } else if ([dictOrArray isKindOfClass:[NSArray class]]) {
        // TODO: add support for tuple typing
        
    } else {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       ([NSString stringWithFormat:@"expected type (schema,array) for attribute '%@'", key]));
        return NO;
    }
    return YES;
}

+ (id) JSONSchemaWithObject:(id)obj error:(NSError**)error
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    
    if (![schema validateAndSetAttribute:JSONSchemaAttributeId fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeExtends fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeType fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeDisallow fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeDescription fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeTitle fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeFormat fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeRequired fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeDefault fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeEnum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeMinimum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeMaximum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeExclusiveMinimum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeExclusiveMaximum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeDivisibleBy fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeMinItems fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeMaxItems fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeMinLength fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributeMaxLength fromObject:obj error:error]) return nil;
    if (![schema validateAndSetAttribute:JSONSchemaAttributePattern fromObject:obj error:error]) return nil;
    
    NSDictionary* properties = [obj valueForKey:JSONSchemaAttributeProperties];
    if (properties != nil) {
        if (![schema addPropertiesFromDict:properties toKey:JSONSchemaAttributeProperties error:error]) {
            return nil;
        }
    }

    NSDictionary* patternProperties = [obj valueForKey:JSONSchemaAttributePatternProperties];
    if (properties != nil) {
        if (![schema addPropertiesFromDict:patternProperties toKey:JSONSchemaAttributePatternProperties error:error]) {
            return nil;
        }
    }

    id items = [obj valueForKey:JSONSchemaAttributeItems];
    if (items != nil) {
        if(![schema setSchemasFromDictOrArray:items toKey:JSONSchemaAttributeItems error:error]) {
            return nil;
        }
    }

    return schema;
}

- (void)setNilValueForKey:(NSString *)key
{
    if ([[NSSet setWithObjects:
          @"required", @"uniqueItems", nil]
         containsObject:key]) {
        [self setValue:@NO forKey:key];
    } else
        [super setNilValueForKey:key];
}

#pragma mark Validation Methods

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

- (BOOL) validateDisallowedTypes:(id*)value error:(NSError**)error
{
    return [self validateTypeKey:@"disallowedTypes" value:value error:error];
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

- (BOOL) validateExtends:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSString class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (string) for attribute 'extends'");
        return NO;
    }
    return YES;
}

- (BOOL) validateDescr:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSString class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (string) for attribute 'description'");
        return NO;
    }
    return YES;
}

- (BOOL) validateFormat:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSString class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (string) for attribute 'format'");
        return NO;
    }
    return YES;
}

- (BOOL) validateMinimum:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (number) for attribute 'minimum'");
        return NO;
    }
    return YES;
}

- (BOOL) validateMaximum:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type 'number' for attribute 'maximum'");
        return NO;
    }
    return YES;
}

- (BOOL) validateExclusiveMinimum:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (number) for attribute 'exclusiveMinimum'");
        return NO;
    }
    return YES;
}

- (BOOL) validateExclusiveMaximum:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (number) for attribute 'exclusiveMaximum'");
        return NO;
    }
    return YES;
}

- (BOOL) validateDivisibleBy:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (number) for attribute 'divisibleBy'");
        return NO;
    }
    // TODO: validate integral
    return YES;
}

- (BOOL) validateMinItems:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (number) for attribute 'minItems'");
        return NO;
    }
    return YES;
}

- (BOOL) validateMaxItems:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (number) for attribute 'maxItems'");
        return NO;
    }
    return YES;
}

- (BOOL) validatePossibleValues:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSArray class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (array) for attribute 'possibleValues'");
        return NO;
    }
    return YES;
}

- (BOOL) validateMinLength:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (number) for attribute 'minLength'");
        return NO;
    }
    return YES;
}

- (BOOL) validateMaxLength:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSNumber class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (number) for attribute 'maxLength'");
        return NO;
    }
    return YES;
}

- (BOOL) validatePattern:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSString class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (string) for attribute 'pattern'");
        return NO;
    }
    return YES;
}

- (BOOL) validateItems:(id*)value error:(NSError**)error
{
    return YES;
}


@end