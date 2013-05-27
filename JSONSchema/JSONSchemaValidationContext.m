//
//  JSONValidationContext.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaValidationContext.h"
#import "JSONSchemaValidationContext+Private.h"
//#import "JSONSchemaValidationLogic.h"
#import "JSONSchemaErrors.h"
#import "JSONSchemaDraft3.h"
#import "NSNumber+JSONSchema.h"
//#import "JSONSchemaValidationLogic+DefaultLogic.h"


@interface JSONSchemaValidationContext ()
@property (nonatomic, strong) NSMutableDictionary* schemasByURL;
@end

@implementation JSONSchemaValidationContext

//- (id)initWithValidationLogic:(JSONSchemaValidationLogic *)logic
- (id)init
{
    self = [super init];
    if (self) {
        self.schemasByURL =  [NSMutableDictionary dictionary];
    }
    return self;
}

//- (id)init
//{
//    return [self initWithValidationLogic:[JSONSchemaValidationLogic defaultValidationLogic]];
//}


- (void) addSchema:(JSONSchemaDraft3*)schema forURL:(NSURL*)url
{
    (self.schemasByURL)[url] = schema;
}

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchemaDocument*)schema
{
    return [schema validate:object context:nil];
}


@end
