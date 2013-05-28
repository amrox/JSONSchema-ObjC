//
//  JSONSchemaObject.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import <Foundation/Foundation.h>

@class JSONSchemaValidationResult;

extern NSString* const JSONSchemaAttributeTitle;

extern NSString* const JSONSchemaTypeObject;
extern NSString* const JSONSchemaTypeString;
extern NSString* const JSONSchemaTypeNumber;
extern NSString* const JSONSchemaTypeInteger;
extern NSString* const JSONSchemaTypeBoolean;
extern NSString* const JSONSchemaTypeArray;
extern NSString* const JSONSchemaTypeNull;
extern NSString* const JSONSchemaTypeAny;


@interface JSONSchemaDocument : NSObject

+ (id) JSONSchemaWithObject:(id)obj error:(NSError**)error;

+ (id) JSONSchemaWithData:(NSData *)data error:(NSError**)error;

+ (id) schema;

+ (NSInteger) version;

- (instancetype) tap:(void (^)(id))block;

+ (instancetype) build:(void (^)(id schema))block;

- (NSDictionary*) dictionaryRepresentation;


// general attributes
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSArray* types; // maps to 'type'
@property (nonatomic, strong) NSString* title;

// object attributes
@property (nonatomic, strong) NSDictionary* properties;
@property (nonatomic, strong) NSDictionary* patternProperties;


#pragma mark -


#pragma mark Validation

- (JSONSchemaValidationResult*) validate:(id)object context:(id)context;

- (JSONSchemaValidationResult*) validate:(id)object;

/**
 @discussion compataibility method
 */
- (BOOL) validate:(id)object errors:(NSArray**)outErrors;

@end
