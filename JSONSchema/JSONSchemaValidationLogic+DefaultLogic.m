//
//  JSONSchemaValidationLogic+DefaultLogic.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/19/13.
//
//

#import "JSONSchemaValidationLogic+DefaultLogic.h"

#import "JSONSchemaDraft3ValidationLogic.h"

@implementation JSONSchemaValidationLogic (Default)

+ (JSONSchemaValidationLogic*) defaultValidationLogic
{
    static dispatch_once_t onceToken;
    static JSONSchemaValidationLogic* defaultInstance = nil;
    dispatch_once(&onceToken, ^{
        // TODO: change to Draft 4 once implemented
        defaultInstance = [[JSONSchemaDraft3ValidationLogic alloc] init];
    });
    return defaultInstance;
}

@end
