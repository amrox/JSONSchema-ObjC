//
//  JSONValidationContext.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaValidationContext.h"
#import "JSONSchemaValidationContext+Private.h"
#import "JSONSchemaValidationLogic.h"
#import "JSONSchemaErrors.h"
#import "JSONSchema.h"
#import "NSNumber+JSONSchema.h"

@interface JSONSchemaValidationContext ()
@property (nonatomic, strong) NSMutableDictionary* schemasByURL;
@end

@implementation JSONSchemaValidationContext

- (id)initWithValidationLogic:(JSONSchemaValidationLogic *)logic
{
    self = [super init];
    if (self) {
        self.schemasByURL =  [NSMutableDictionary dictionary];
        self.logic = logic;
    }
    return self;
}

- (id)init
{
    return [self initWithValidationLogic:[JSONSchemaValidationLogic defaultValidationLogic]];
}


- (void) addSchema:(JSONSchema*)schema forURL:(NSURL*)url
{
    [self.schemasByURL setObject:schema forKey:url];
}

- (JSONSchemaValidationResult*) validate:(id)object againstSchema:(JSONSchema*)schema
{
    return [self.logic validate:object againstSchema:schema context:nil];
}


@end
