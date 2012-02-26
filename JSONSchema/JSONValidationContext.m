//
//  JSONValidationContext.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONValidationContext.h"

@interface JSONValidationContext ()
@property (nonatomic, retain) NSMutableDictionary* schemasByURL;
@end

@implementation JSONValidationContext

@synthesize schemasByURL = _schemasByURL;

- (id)init
{
    self = [super init];
    if (self) {
        _schemasByURL = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_schemasByURL release];
    [super dealloc];
}

- (void) addSchema:(JSONSchema*)schema forURL:(NSURL*)url
{
    [self.schemasByURL setObject:schema forKey:url];
}


@end
