//
//  NSNumber+JSONSchema.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+JSONSchema.h"

@implementation NSNumber (JSONSchema)

- (BOOL) jsonSchema_isIntegral
{
    // TODO: might be a better way to do this
    return [self isEqualToNumber:@([self integerValue])];
}

@end
