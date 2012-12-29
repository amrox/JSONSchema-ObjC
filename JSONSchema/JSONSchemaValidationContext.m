//
//  JSONValidationContext.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaValidationContext.h"
#import "JSONSchemaValidationRules.h"
#import "JSONSchemaErrors.h"
#import "JSONSchema.h"
#import "NSNumber+JSONSchema.h"

@interface JSONSchemaValidationContext ()
@property (nonatomic, strong) NSMutableDictionary* schemasByURL;
@property (nonatomic, strong, readwrite) JSONSchemaValidationRules* rules;
@end

@implementation JSONSchemaValidationContext

- (id)initWithRules:(JSONSchemaValidationRules *)rules
{
    self = [super init];
    if (self) {
        self.schemasByURL =  [NSMutableDictionary dictionary];
        self.rules = rules;
    }
    return self;
}

- (id)init
{
    return [self initWithRules:[JSONSchemaValidationRules defaultRules]];
}


- (void) addSchema:(JSONSchema*)schema forURL:(NSURL*)url
{
    [self.schemasByURL setObject:schema forKey:url];
}

- (BOOL) validate:(id)object againstSchema:(JSONSchema*)schema errors:(NSArray**)errors;
{
    return [self.rules validate:object againstSchema:schema context:nil errors:errors];
}


@end
