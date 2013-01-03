//
//  JSONSchema.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const JSONSchemaAttributeId;
extern NSString* const JSONSchemaAttributeExtends;
extern NSString* const JSONSchemaAttributeType;
extern NSString* const JSONSchemaAttributeDisallow;
extern NSString* const JSONSchemaAttributeDescription;
extern NSString* const JSONSchemaAttributeTitle;
extern NSString* const JSONSchemaAttributeFormat;
extern NSString* const JSONSchemaAttributeProperties;
extern NSString* const JSONSchemaAttributePatternProperties;
extern NSString* const JSONSchemaAttributeRequired;
extern NSString* const JSONSchemaAttributeDefault;
extern NSString* const JSONSchemaAttributeMinimum;
extern NSString* const JSONSchemaAttributeMaximum;
extern NSString* const JSONSchemaAttributeExclusiveMinimum;
extern NSString* const JSONSchemaAttributeExclusiveMaximum;
extern NSString* const JSONSchemaAttributeMinItems;
extern NSString* const JSONSchemaAttributeMaxItems;
extern NSString* const JSONSchemaAttributeUniqueItems;
extern NSString* const JSONSchemaAttributeMinLength;
extern NSString* const JSONSchemaAttributeMaxLength;
extern NSString* const JSONSchemaAttributePattern;

extern NSString* const JSONSchemaTypeObject;
extern NSString* const JSONSchemaTypeString;
extern NSString* const JSONSchemaTypeNumber;
extern NSString* const JSONSchemaTypeInteger;
extern NSString* const JSONSchemaTypeBoolean;
extern NSString* const JSONSchemaTypeArray;
extern NSString* const JSONSchemaTypeNull;
extern NSString* const JSONSchemaTypeAny;

extern NSString* const JSONSchemaFormatDatetime;
extern NSString* const JSONSchemaFormatDate;
extern NSString* const JSONSchemaFormatTime;
extern NSString* const JSONSchemaFormatUTCMillisec;
extern NSString* const JSONSchemaFormatRegex;
extern NSString* const JSONSchemaFormatColor;
extern NSString* const JSONSchemaFormatStyle;
extern NSString* const JSONSchemaFormatPhone;
extern NSString* const JSONSchemaFormatURI;
extern NSString* const JSONSchemaFormatEmail;
extern NSString* const JSONSchemaFormatIPAddress;
extern NSString* const JSONSchemaFormatIPV6Address;
extern NSString* const JSONSchemaFormatHostname;

@protocol JSONSchemaSerializationHelper <NSObject>

+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error;

@end

@interface JSONSchema : NSObject

+ (void) setSharedJSONSerializationHelper:(Class<JSONSchemaSerializationHelper>)helper;

+ (id) JSONSchemaWithData:(NSData *)data error:(NSError**)error;

+ (id) JSONSchemaWithObject:(id)obj error:(NSError**)error;

+ (id) build:(void (^)(JSONSchema* schema))block;

+ (id) JSONSchema;

// general attributes
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* extends;
@property (nonatomic, strong) NSArray* types; // maps to 'type'
@property (nonatomic, strong) NSArray* disallowedTypes; // maps to 'disallow'
@property (nonatomic, strong) NSString* schemaDescription;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* format;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, strong) id defaultValue; // maps to 'default'
@property (nonatomic, strong) NSArray* possibleValues; // maps to 'enum'

// object attributes
@property (nonatomic, strong) NSDictionary* properties;
@property (nonatomic, strong) NSDictionary* patternProperties;

// number attributes
@property (nonatomic, strong) NSNumber* minimum;
@property (nonatomic, strong) NSNumber* maximum;
@property (nonatomic, strong) NSNumber* exclusiveMinimum;
@property (nonatomic, strong) NSNumber* exclusiveMaximum;
@property (nonatomic, strong) NSNumber* divisibleBy;

// array attributes
@property (nonatomic, strong) NSNumber* minItems; // ???: make integer?
@property (nonatomic, strong) NSNumber* maxItems; // ???: make integer?
@property (nonatomic, assign) BOOL uniqueItems;
@property (nonatomic, strong) id items;
@property (nonatomic, strong) id additionalItems;

// string attributes
@property (nonatomic, strong) NSNumber* minLength;
@property (nonatomic, strong) NSNumber* maxLength;
@property (nonatomic, strong) NSString* pattern;

#pragma mark -

/*
 @discussion returns the value for a "JSONSchemaAttribute"
 */
- (id) valueForAttribute:(NSString*)attribute;

@end


@interface NSJSONSerialization (JSONSchemaSerializationHelper) <JSONSchemaSerializationHelper>

@end