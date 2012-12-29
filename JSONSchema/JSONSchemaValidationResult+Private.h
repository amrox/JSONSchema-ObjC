//
//  JSONSchemaValidationContext+Private.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 9/29/12.
//
//

#import "JSONSchemaValidationResult.h"

@interface JSONSchemaValidationResult ()

- (void)addError:(NSError *error);

@end