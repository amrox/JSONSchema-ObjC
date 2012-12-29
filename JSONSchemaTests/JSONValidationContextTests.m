//
//  JSONValidationContextTests.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONValidationContextTests.h"
#import "TestUtility.h"
#import "JSONSchemaValidationContext.h"
#import "JSONSchema.h"

@implementation JSONValidationContextTests

- (void) testValidateStringOK
{
    NSString* schemaString = @"{\"type\":\"string\"}";
    NSData* schemaData = [schemaString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    JSONSchema* schema = [JSONSchema JSONSchemaWithData:schemaData error:&error];
    STAssertNotNil(schema, @"error: %@", error);
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"errors: %@", errors);
}

- (void) testValidateStringGoodType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateStringBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
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
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
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
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"fart" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateStringGoodPattern
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    schema.pattern = @"bo.";

    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"boo" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateStringBadPattern
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    schema.pattern = @"bo.";
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"foo" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodTypeInteger
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];

    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];

    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberGoodTypeFloat
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithFloat:5.5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"pineapple" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateIntegerGood
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeInteger];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateIntegerBadFloat
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeInteger];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithFloat:5.5] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}


- (void) testValidateNumberGoodMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.minimum = [NSNumber numberWithInteger:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.minimum = [NSNumber numberWithInteger:4];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberGoodExclusiveMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.exclusiveMinimum = [NSNumber numberWithInteger:4];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.exclusiveMinimum = [NSNumber numberWithInteger:4];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberBadMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.minimum = [NSNumber numberWithInteger:5];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.maximum = [NSNumber numberWithInteger:5];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.maximum = [NSNumber numberWithInteger:5];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.maximum = [NSNumber numberWithInteger:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodExclusiveMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.exclusiveMaximum = [NSNumber numberWithInteger:5];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.exclusiveMaximum = [NSNumber numberWithInteger:4];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanGoodTrue
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeBoolean];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithBool:YES] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanGoodFalse
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeBoolean];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithBool:NO] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanBadNumber
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeBoolean];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeBoolean];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"purple" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByGood
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.divisibleBy = [NSNumber numberWithInteger:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberDivisbleByBadDivide
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.divisibleBy = [NSNumber numberWithInteger:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInteger:3] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.divisibleBy = [NSNumber numberWithInteger:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/number"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithFloat:4.5f] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSArray array] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSArray array] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayGoodMinItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.minItems = [NSNumber numberWithInt:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMinItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.minItems = [NSNumber numberWithInt:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodMaxItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.maxItems = [NSNumber numberWithInt:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMaxItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.maxItems = [NSNumber numberWithInt:2];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodUniqueItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.uniqueItems = YES;
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];

    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];

    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadUniqueItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.uniqueItems = YES;
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", @"two", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodEnum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"cat", @"bear"];

    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];

    NSArray* array = [NSArray arrayWithObjects:@"dog", @"cat", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadEnum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"bear"];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/array"]];
    
    NSArray* array = [NSArray arrayWithObjects:@"dog", @"cat", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateDisallowPass
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.disallowedTypes = [NSArray arrayWithObject:JSONSchemaTypeInteger];

    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateDisallowFail
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.disallowedTypes = [NSArray arrayWithObject:JSONSchemaTypeInteger];
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/string"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:[NSNumber numberWithInt:1] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateRequiredPropertyFail
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.properties = @{@"purple" : [JSONSchema build:^(JSONSchema *schema) {
        schema.required = YES;
    }]};
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/schema"]];

    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@{@"green": @1}
                                 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateRequiredPropertyPass
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.properties = @{@"purple" : [JSONSchema build:^(JSONSchema *schema) {
        schema.required = YES;
    }]};
    
    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/schema"]];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@{@"purple": @1}
                                 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidatePropertyTypeFail
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.properties = @{@"purple" : [JSONSchema build:^(JSONSchema *schema) {
        schema.types = @[JSONSchemaTypeInteger];
    }]};

    JSONSchemaValidationContext* context = [[JSONSchemaValidationContext alloc] init];
//    [context retain];
    [context addSchema:schema forURL:[NSURL URLWithString:@"http://test/schema"]];

    NSArray* errors = nil;
    BOOL validationSuccess = [context validate:@{@"purple": @"hi"}
                                 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

@end
