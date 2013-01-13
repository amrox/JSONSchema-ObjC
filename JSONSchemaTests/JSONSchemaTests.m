//
//  JSONSchemaTests.m
//  JSONSchemaTests
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaTests.h"
#import "JSONSchema.h"
#import "JSONSchemaErrors.h"
#import "TestUtility.h"

#import "JSONSchema+ObjectCreation.h"

@implementation JSONSchemaTests

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
    JSONSchema* schema = [JSONSchema schema];

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
    JSONSchema* schema = [JSONSchema schema];
    
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
    JSONSchema* schema = [JSONSchema JSONSchemaWithData:data error:&error];
    STAssertNotNil(schema, @"error: %@", error);
}

- (void) testCreateObject
{
    // Set up a basic JSON-Schema for a "Hat" object. It has a single property "color",
    // which is a string and can have the values ("red", "green", "blue").
    
    NSDictionary* schemaDict = @{
        @"title" : @"Hat",
        @"properties" : @{@"color" : @{
            @"type": @"string",
            @"enum": @[@"red", @"green", @"blue"]
        }}
    };
    
    NSError* error = nil;
    JSONSchema* schema = [JSONSchema JSONSchemaWithObject:schemaDict error:&error];
    STAssertNil(error, @"error: %@", error);
    
    // Create an instance of the object defined by the schema
    
    id obj = [schema createObject];

    // Test set and get valid value
    
    [obj setValue:@"red" forKey:@"color"];
    STAssertEqualObjects([obj valueForKey:@"color"], @"red", @"should be red");

    // Test set invalid value

    STAssertThrows([obj setValue:@"purple" forKey:@"color"], @"should throw for invalid value");
}

@end
