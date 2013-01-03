//
//  JSONSchema.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchema.h"
#import "JSONSchemaErrors.h"

NSString* const JSONSchemaAttributeId                = @"id";
NSString* const JSONSchemaAttributeExtends           = @"extends";
NSString* const JSONSchemaAttributeType              = @"type";
NSString* const JSONSchemaAttributeDisallow          = @"disallow";
NSString* const JSONSchemaAttributeDescription       = @"description";
NSString* const JSONSchemaAttributeTitle             = @"title";
NSString* const JSONSchemaAttributeFormat            = @"format";
NSString* const JSONSchemaAttributeProperties        = @"properties";
NSString* const JSONSchemaAttributePatternProperties = @"patternProperties";
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

NSString* const JSONSchemaTypeObject                 = @"object";
NSString* const JSONSchemaTypeString                 = @"string";
NSString* const JSONSchemaTypeNumber                 = @"number";
NSString* const JSONSchemaTypeInteger                = @"integer";
NSString* const JSONSchemaTypeBoolean                = @"boolean";
NSString* const JSONSchemaTypeArray                  = @"array";
NSString* const JSONSchemaTypeNull                   = @"null";
NSString* const JSONSchemaTypeAny                    = @"any";

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

@implementation JSONSchema

static Class<JSONSchemaSerializationHelper> _JSONSerialization = nil;

@synthesize id = _id;
@synthesize extends = _extends;
@synthesize types = _types;
@synthesize disallowedTypes = _disallowedTypes;
@synthesize schemaDescription = _description;
@synthesize title = _title;
@synthesize format = _format;
@synthesize required = _required;
@synthesize defaultValue = _defaultValue;
@synthesize possibleValues = _possibleValues;
@synthesize properties = _properties;
@synthesize patternProperties = _patternProperties;
@synthesize minimum = _minimum;
@synthesize maximum = _maximum;
@synthesize exclusiveMinimum  = _exclusiveMinimum;
@synthesize exclusiveMaximum = _exclusiveMaximum;
@synthesize divisibleBy = _divisibleBy;
@synthesize minItems = _minItems;
@synthesize maxItems = _maxItems;
@synthesize uniqueItems = _uniqueItems;
@synthesize pattern = _pattern;
@synthesize minLength = _minLength;
@synthesize maxLength = _maxLength;

+ (void) setSharedJSONSerializationHelper:(Class<JSONSchemaSerializationHelper>)helper
{
    _JSONSerialization = helper;
}

+ (Class<JSONSchemaSerializationHelper>) sharedSerializationHelper
{
    NSParameterAssert(_JSONSerialization);
    return _JSONSerialization;
}

+ (void) initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"NSJSONSerialization");
        if (cls != nil) {
            [self setSharedJSONSerializationHelper:cls];
        }
    });
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

// if the source object key and my key differ
- (BOOL) validateAndSetKey:(NSString*)key fromObject:(id)object objectKey:(NSString*)objectKey error:(NSError**)outError
{
    id value = [object valueForKey:objectKey];
    if (![self validateValue:&value forKey:key error:outError]) {
        return NO;
    }
    [self setValue:value forKey:key];
    
    return YES;    
}

// if the source object key and my key are the same (common case)
- (BOOL) validateAndSetKey:(NSString*)key fromObject:(id)object error:(NSError**)outError
{
    return [self validateAndSetKey:key fromObject:object objectKey:key error:outError];
}

- (BOOL) addPropertiesFromDict:(NSDictionary*)dict toKey:(NSString*)key error:(NSError**)error
{
    NSArray* allPropertyNames = [dict allKeys];
    NSMutableDictionary* properties = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
    [self setValue:properties forKey:key];
    
    for (NSString* propertyName in allPropertyNames) {
        id value = dict[propertyName];
        JSONSchema* propertySchema = [[self class] JSONSchemaWithObject:value error:error];
        if (propertySchema == nil) {
            return NO;
        }
        properties[propertyName] = propertySchema;
    }
    return YES;
}

+ (id) build:(void (^)(JSONSchema* schema))block
{
    JSONSchema* schema = [JSONSchema schema];
    block(schema);
    return schema;
}

+ (id) JSONSchemaWithObject:(id)obj error:(NSError**)error
{
    JSONSchema* schema = [JSONSchema schema];
    
    if (![schema validateAndSetKey:JSONSchemaAttributeId fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeExtends fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:@"types" fromObject:obj objectKey:JSONSchemaAttributeType error:error]) return nil;
    if (![schema validateAndSetKey:@"disallowedTypes" fromObject:obj objectKey:JSONSchemaAttributeDisallow error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeDescription fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeTitle fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeFormat fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeRequired fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:@"defaultValue" fromObject:obj objectKey:JSONSchemaAttributeDefault error:error]) return nil;
    if (![schema validateAndSetKey:@"possibleValues" fromObject:obj objectKey:JSONSchemaAttributeEnum error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeMinimum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeMaximum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeExclusiveMinimum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeExclusiveMaximum fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeDivisibleBy fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeMinItems fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeMaxItems fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeMinLength fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributeMaxLength fromObject:obj error:error]) return nil;
    if (![schema validateAndSetKey:JSONSchemaAttributePattern fromObject:obj error:error]) return nil;
    
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
    
    return schema;
}

+ (id)JSONSchemaWithData:(NSData *)data error:(NSError**)error
{
    id obj = [[self sharedSerializationHelper] JSONObjectWithData:data error:error];
    if (obj == nil) {
        //JSERR_P(error, JSONSCHEMA_ERROR_PARSE_FAIL);
        return nil;
    }
    return [self JSONSchemaWithObject:obj error:error];
}

+ (id) schema
{
    return [[self alloc] init];
}


+ (NSArray*) allAttributes
{
    return @[
    JSONSchemaAttributeId,
    JSONSchemaAttributeExtends,
    JSONSchemaAttributeType,
    JSONSchemaAttributeDisallow,
    JSONSchemaAttributeTitle,
    JSONSchemaAttributeFormat,
    JSONSchemaAttributeProperties,
    JSONSchemaAttributePatternProperties,
    JSONSchemaAttributeRequired,
    JSONSchemaAttributeDefault,
    JSONSchemaAttributeEnum,
    JSONSchemaAttributeMinimum,
    JSONSchemaAttributeMaximum,
    JSONSchemaAttributeExclusiveMinimum,
    JSONSchemaAttributeExclusiveMaximum,
    JSONSchemaAttributeDivisibleBy,
    JSONSchemaAttributeMinItems,
    JSONSchemaAttributeMaxItems,
    JSONSchemaAttributeUniqueItems,
    JSONSchemaAttributeMinLength,
    JSONSchemaAttributeMaxLength,
    JSONSchemaAttributePattern,
    ];
}

+ (NSString*) propertyNameForAttributeName:(NSString*)attributeName
{
    if ([attributeName isEqualToString:JSONSchemaAttributeType]) {
        return NSStringFromSelector(@selector(types));
    }
    
    else if ([attributeName isEqualToString:JSONSchemaAttributeDisallow]) {
        return NSStringFromSelector(@selector(disallowedTypes));
    }
    
    else if ([attributeName isEqualToString:JSONSchemaAttributeDefault]) {
        return NSStringFromSelector(@selector(defaultValue));
    }
    
    else if ([attributeName isEqualToString:JSONSchemaAttributeEnum]) {
        return NSStringFromSelector(@selector(possibleValues));
    }
    
    return attributeName;
}

- (id) valueForAttribute:(NSString*)attribute
{
    NSString* key = [[self class] propertyNameForAttributeName:attribute];
    return [self valueForKey:key];
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

- (BOOL) validateSchemaDescription:(id*)value error:(NSError**)error
{
    if (*value != nil && ![*value isKindOfClass:[NSString class]]) {
        JSERR_REASON_P(error, JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE,
                       @"expected type (string) for attribute 'description'");
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

- (NSString*) description
{
    return [[self dictionaryRepresentation] description];
}

@end


@implementation NSJSONSerialization (JSONSchemaSerializationHelper)

+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error
{
    return [self JSONObjectWithData:data options:0 error:error];
}

@end