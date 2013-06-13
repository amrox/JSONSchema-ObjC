//
//  JSONSchemaObjectContext.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 6/12/13.
//
//

#import <Foundation/Foundation.h>

@interface JSONSchemaObjectContext : NSObject

- (void)pushContext:(NSString*)contextName;

- (NSString*) popContext;

@end
