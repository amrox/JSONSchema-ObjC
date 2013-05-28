//
//  JSONSchemaDraft4.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONSchemaDocument.h"

extern NSString* const JSONSchemaAttributeMultipleOf;


@interface JSONSchemaDocument_v4 : JSONSchemaDocument

// numeric
@property (nonatomic, strong) NSNumber* multipleOf;
@property (nonatomic, strong) NSNumber* minimum;
@property (nonatomic, strong) NSNumber* maximum;
@property (nonatomic, strong) NSNumber* exclusiveMinimum;
@property (nonatomic, strong) NSNumber* exclusiveMaximum;

@end
