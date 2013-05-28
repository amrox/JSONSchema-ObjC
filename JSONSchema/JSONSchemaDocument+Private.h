//
//  JSONSchemaDocument+Private.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import "JSONSchemaDocument.h"

@interface JSONSchemaDocument ()

#pragma mark Subclasses Must Override

// if the property name on the classes differs from the property name in JSON-Schema
+ (NSDictionary*) attributeToPropertyMap;


#pragma mark Internal Helpers

/*
 @discussion returns the value for a "JSONSchemaAttribute"
 */
- (id) valueForAttribute:(NSString*)attribute;

- (BOOL) validateAndSetAttribute:(NSString*)attr fromObject:(id)object error:(NSError**)outError;

+ (NSString*) attributeNameForPropertyName:(NSString*)propertyName;

+ (NSString*) propertyNameForAttributeName:(NSString*)attributeName;

- (BOOL) validateTypeKey:(NSString*)key value:(id*)value error:(NSError**)error;

@end
