//
//  JSONSchemaDocument_v4_Tests.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import "JSONSchemaDocument_v4_Tests.h"

#import "JSONSchemaDocument_v4.h"

@implementation JSONSchemaDocument_v4_Tests

- (void) testValidMultipleOf
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @1;
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"multipleOf" error:&error];
    STAssertTrue(valid, @"should succeed");
}

- (void) testInvalidMultipleOf_WrongType
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @"hi";
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"multipleOf" error:&error];
    STAssertFalse(valid, @"should fail");
}

- (void) testInvalidMultipleOf_BadValue
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @-1;
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"multipleOf" error:&error];
    STAssertFalse(valid, @"should fail");
}


@end
