//
//  JSONSchemaValidationResult.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 9/29/12.
//
//

#import <Foundation/Foundation.h>

@interface JSONSchemaValidationResult : NSObject

- (NSArray*) errors;

- (BOOL) isValid;

@end
