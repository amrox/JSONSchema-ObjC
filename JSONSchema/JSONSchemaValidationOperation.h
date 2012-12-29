//
//  JSONSchemaValidationOperation.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 11/17/12.
//
//

#import <Foundation/Foundation.h>

@class JSONSchemaValidationContext;
@class JSONSchemaValidationResult;

@interface JSONSchemaValidationOperation : NSOperation

- (id)initWithContext:(JSONSchemaValidationContext *)context object:(id)object;

@property (nonatomic, retain, readonly) JSONSchemaValidationResult *result;

@end
