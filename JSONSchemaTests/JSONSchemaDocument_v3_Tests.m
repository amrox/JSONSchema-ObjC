//
//  JSONSchemaTests.m
//  JSONSchemaTests
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaDocument_v3_Tests.h"
#import "JSONSchemaDocument_v3.h"
#import "JSONSchemaErrors.h"
#import "TestUtility.h"


@implementation JSONSchemaDocument_v3_Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

//- (void)testMissingType
//{
//    NSString* jsonString = @"{}";
//    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSError* error = nil;
//    id schema = [JSONSchema JSONSchemaWithData:jsonData error:&error];
//    STAssertNil(schema, @"schema should be nil");
//    STAssertTrue([error code]==JSONSCHEMA_ERROR_NIL_TYPE, @"should be JSONSCHEMA_ERROR_NIL_TYPE");
//}

- (void) testValidateType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];

    id type = nil;
    NSError* error = nil;
    BOOL valid = NO;
    
    type = JSONSchemaTypeObject;
    valid = [schema validateValue:&type forKey:@"types" error:&error];
    STAssertTrue(valid, @"error: %@", error);
    
    type = @"fart";
    valid = [schema validateValue:&type forKey:@"types" error:&error];
    STAssertFalse(valid, @"error: %@", error);
    
    type = @[@"string", @"object"];
    valid = [schema validateValue:&type forKey:@"types" error:&error];
    STAssertTrue(valid, @"error: %@", error);
            
    type = @[@"string", @"pickle"];
    valid = [schema validateValue:&type forKey:@"types" error:&error];
    STAssertFalse(valid, @"error: %@", error);
}

- (void) testInvalidDescriptionType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    
    NSNumber* n = @1;
    NSError* error = nil;
    BOOL valid = NO;
    
    valid = [schema validateValue:&n forKey:@"schemaDescription" error:&error];
    STAssertFalse(valid, @"should fail");
    
}

- (void) testParseProduct
{
    NSString* path = TEST_RESOURCE_PATH(@"Product.json");
    STAssertNotNil(path, @"path is nil");
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    NSError* error = nil;
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 JSONSchemaWithData:data error:&error];
    STAssertNotNil(schema, @"error: %@", error);
}

- (void) testParseItemsSchema
{
    NSString* schemaString = @"{\"type\": \"array\", \"items\": {\"type\": \"integer\"}}";
    NSData* schemaData = [schemaString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 JSONSchemaWithData:schemaData error:&error];
    STAssertNotNil(schema, @"error: %@", error);
    STAssertTrue([schema.items isKindOfClass:[JSONSchemaDocument_v3 class]], @"schema.items should be a schema v3.");
}


@end
