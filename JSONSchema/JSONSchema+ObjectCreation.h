//
//  JSONSchema+ObjectCreation.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 1/12/13.
//
//

#import "JSONSchema.h"

@interface JSONSchema (ObjectCreation)

- (Class) registerClass;

- (Class) registerClassWithName:(NSString*)className;


@end

@interface NSObject (JSONSchema)

- (JSONSchema *) JSONSchema;

@end
