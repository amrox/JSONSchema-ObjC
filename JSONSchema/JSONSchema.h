//
//  JSONSchema.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONSchemaErrors.h"
#import "JSONSchemaSerializationHelper.h"
#import "JSONSchemaDocument.h"
#import "JSONSchemaValidationContext.h"
#import "JSONSchemaValidationResult.h"

@interface JSONSchema : NSObject

+ (Class) documentClassForSchemaVersion:(NSInteger)version;

+ (void) registerDocumentClass:(Class)cls;


#pragma mark -

+ (NSInteger) defaultSchemaVersion;

+ (void) setDefaultSchemaVersion:(NSInteger)version;

+ (Class) defaultSchemaDocumentClass;


#pragma mark -

+ (Class<JSONSchemaSerializationHelper>) sharedSerializationHelper;

+ (void) setSharedJSONSerializationHelper:(Class<JSONSchemaSerializationHelper>)helper;

@end