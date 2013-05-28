//
//  JSONSchemaDictionaryRepresentation.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import <Foundation/Foundation.h>

@protocol JSONSchemaDictionaryRepresentation <NSObject>

- (id) jsonSchema_dictionaryRepresentation;

@end


@protocol JSONSchemaDictionaryTransformable <NSObject>

@optional
- (NSString*) jsonSchema_dictionaryKeyForPropertyName:(NSString*)propertyName;

@end


@interface NSObject (JSONSchemaDictionaryRepresentation) <JSONSchemaDictionaryRepresentation>

- (id) jsonSchema_dictionaryRepresentation;

@end


