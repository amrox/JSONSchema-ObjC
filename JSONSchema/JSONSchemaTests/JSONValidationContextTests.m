//
//  JSONValidationContextTests.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONValidationContextTests.h"
#import "TestUtility.h"
#import "JSONValidationContext.h"
#import "JSONSchema.h"

@implementation JSONValidationContextTests

- (void) testValidateStringOK
{
    NSString* schemaString = @"{\"type\":\"string\"}";
    NSData* schemaData = [schemaString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    JSONSchema* schema = [JSONSchema JSONSchemaWithData:schemaData error:&error];
    STAssertNotNil(schema, @"error: %@", error);
    
    JSONValidationContext* context = [[[JSONValidationContext alloc] init] autorelease];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"errors: %@", errors);
}

- (void) testValidateStringGood
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    
    JSONValidationContext* context = [[[JSONValidationContext alloc] init] autorelease];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateStringBad
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    
    JSONValidationContext* context = [[[JSONValidationContext alloc] init] autorelease];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInt:1] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateStringBadMinLength
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    schema.minLength = [NSNumber numberWithInt:10];
    
    JSONValidationContext* context = [[[JSONValidationContext alloc] init] autorelease];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"fart" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateStringBadMaxLength
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    schema.maxLength = [NSNumber numberWithInt:2];
    
    JSONValidationContext* context = [[[JSONValidationContext alloc] init] autorelease];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"fart" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

@end
