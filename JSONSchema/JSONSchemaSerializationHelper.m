//
//  JSONSchemaSerializationHelper2.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import "JSONSchemaSerializationHelper.h"


@implementation NSJSONSerialization (JSONSchemaSerializationHelper)

+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error
{
    return [self JSONObjectWithData:data options:0 error:error];
}

@end