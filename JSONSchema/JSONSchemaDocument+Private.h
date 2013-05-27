//
//  JSONSchemaDocument+Private.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import "JSONSchemaDocument.h"

@interface JSONSchemaDocument ()

// if the source object key and my key differ
- (BOOL) validateAndSetKey:(NSString*)key fromObject:(id)object objectKey:(NSString*)objectKey error:(NSError**)outError;

// if the source object key and my key are the same (common case)
- (BOOL) validateAndSetKey:(NSString*)key fromObject:(id)object error:(NSError**)outError;

@end
