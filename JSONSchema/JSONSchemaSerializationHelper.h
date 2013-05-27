//
//  Header.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

@protocol JSONSchemaSerializationHelper <NSObject>

+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error;

@end


@interface NSJSONSerialization (JSONSchemaSerializationHelper) <JSONSchemaSerializationHelper>

@end
