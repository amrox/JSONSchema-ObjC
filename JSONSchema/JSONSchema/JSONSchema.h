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

+ (id) JSONSchema;

// general attributes
@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* extends;
@property (nonatomic, retain) NSArray* types; // maps to 'type'
@property (nonatomic, retain) NSArray* disallowedTypes; // maps to 'disallow'
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* format;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, retain) id defaultValue; // maps to 'default'
@property (nonatomic, retain) NSArray* possibleValues; // maps to 'enum'

// object attributes
@property (nonatomic, retain) NSMutableDictionary* properties;
@property (nonatomic, retain) NSMutableDictionary* patternProperties;

// number attributes
@property (nonatomic, retain) NSNumber* minimum;
@property (nonatomic, retain) NSNumber* maximum;
@property (nonatomic, retain) NSNumber* exclusiveMinimum;
@property (nonatomic, retain) NSNumber* exclusiveMaximum;
@property (nonatomic, retain) NSNumber* divisibleBy;

// array attributes
@property (nonatomic, retain) NSNumber* minItems; // ???: make integer?
@property (nonatomic, retain) NSNumber* maxItems; // ???: make integer?
@property (nonatomic, assign) BOOL uniqueItems;

// string properties
@property (nonatomic, assign) NSNumber* minLength;
@property (nonatomic, assign) NSNumber* maxLength;
@property (nonatomic, retain) NSString* pattern;

@end


@interface NSJSONSerialization (JSONSchemaSerializationHelper) <JSONSchemaSerializationHelper>

@end