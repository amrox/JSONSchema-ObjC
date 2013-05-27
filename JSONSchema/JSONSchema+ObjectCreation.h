//
//  JSONSchema+ObjectCreation.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 1/12/13.
//
//

#import "JSONSchemaDocument.h"

@interface JSONSchemaDocument (ObjectCreation)

- (Class) registerClass;

- (Class) registerClassWithName:(NSString*)className;


@end

@interface NSObject (JSONSchema)

- (JSONSchemaDocument *) JSONSchemaDocument;

@end
