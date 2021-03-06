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

- (void) testValidMinimum
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @1;
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"minimum" error:&error];
    XCTAssertTrue(valid, @"should succeed");
}

- (void) testInvalidMinimum
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @"hi";
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"minimum" error:&error];
    XCTAssertFalse(valid, @"should fail");
}

- (void) testValidMaximum
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @1;
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"maximum" error:&error];
    XCTAssertTrue(valid, @"should succeed");

}

- (void) testInvalidMaximum
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @"hi";
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"maximum" error:&error];
    XCTAssertFalse(valid, @"should fail");
}

- (void) testValidMultipleOf
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @1;
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"multipleOf" error:&error];
    XCTAssertTrue(valid, @"should succeed");
}

- (void) testInvalidMultipleOf_WrongType
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @"hi";
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"multipleOf" error:&error];
    XCTAssertFalse(valid, @"should fail");
}

- (void) testInvalidMultipleOf_BadValue
{
    JSONSchemaDocument_v4* schema = [JSONSchemaDocument_v4 schema];

    id val = @-1;
    NSError* error = nil;
    BOOL valid = NO;

    valid = [schema validateValue:&val forKey:@"multipleOf" error:&error];
    XCTAssertFalse(valid, @"should fail");
}


@end
