//
//  JSONSchema.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSchemaDocument.h"

extern NSString* const JSONSchemaAttributeExtends;
extern NSString* const JSONSchemaAttributeDisallow;
extern NSString* const JSONSchemaAttributeDescription;
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

@interface JSONSchemaDocument_v3 : JSONSchemaDocument

// general attributes
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* extends;
@property (nonatomic, strong) NSArray* types; // maps to 'type'
@property (nonatomic, strong) NSArray* disallowedTypes; // maps to 'disallow'
@property (nonatomic, strong) NSString* descr; // maps to 'description'
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* format;
@property (nonatomic, assign) NSNumber* required;
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
@property (nonatomic, strong) NSNumber* minItems;
@property (nonatomic, strong) NSNumber* maxItems;
@property (nonatomic, assign) NSNumber* uniqueItems;
@property (nonatomic, strong) id items;
@property (nonatomic, strong) id additionalItems;

// string attributes
@property (nonatomic, strong) NSNumber* minLength;
@property (nonatomic, strong) NSNumber* maxLength;
@property (nonatomic, strong) NSString* pattern;

@end
