//
//  JSONValidationContextTests.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaDraft3ValidationLogicTests.h"
#import "TestUtility.h"
#import "JSONSchemaDocument_v3.h"
#import "JSONSchemaDocument_v3+Validation.h"
#import "JSONSchemaValidationResult.h"

@interface JSONSchemaDraft3ValidationLogicTests ()


@end

@implementation JSONSchemaDraft3ValidationLogicTests

- (void) testLoadSchemaFromString
{
    NSString* schemaString = @"{\"type\":\"string\"}";
    NSData* schemaData = [schemaString dataUsingEncoding:NSUTF8StringEncoding];

    NSError* error = nil;
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 JSONSchemaWithData:schemaData error:&error];
    STAssertNotNil(schema, @"error: %@", error);
}

- (void) testValidateStringOK
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];

    JSONSchemaValidationResult* result = [schema validate:@"fart"];
    STAssertTrue([result isValid], @"errors: %@", result.errors);
}

- (void) testValidateStringGoodType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];

    JSONSchemaValidationResult* result =  [schema validate:@"fart"];
    STAssertTrue([result isValid], @"errors: %@", result.errors);
}

- (void) testValidateStringBadType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];

    JSONSchemaValidationResult* result = [schema validate:@1];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringBadMinLength
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.minLength = @10;

    JSONSchemaValidationResult* result = [schema validate:@"fart"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringBadMaxLength
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.maxLength = @2;

    JSONSchemaValidationResult* result = [schema validate:@"fart"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringGoodPattern
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.pattern = @"bo.";

    JSONSchemaValidationResult* result = [schema validate:@"boo"];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateStringBadPattern
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.pattern = @"bo.";

    JSONSchemaValidationResult* result =  [schema validate:@"foo"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringGoodEnum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.possibleValues = @[@"dog", @"cat"];

    JSONSchemaValidationResult* result = [schema validate:@"dog"];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateStringBadEnum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.possibleValues = @[@"dog", @"cat"];

    JSONSchemaValidationResult* result = [schema validate:@"walrus"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateNumberGoodTypeInteger
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];

    JSONSchemaValidationResult* result = [schema validate:@5];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateNumberGoodTypeFloat
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];

    JSONSchemaValidationResult* result = [schema validate:@5.5f];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateNumberBadType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];

    JSONSchemaValidationResult* result = [schema validate:@"pineapple"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateIntegerGood
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateIntegerBadFloat
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5.5f errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}


- (void) testValidateNumberGoodMinimum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMinimum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @4;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberGoodExclusiveMinimum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMinimum = @4;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMinimum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMinimum = @4;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberBadMinimum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @5;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodMaximum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @5;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMaximum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @5;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadMaximum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodExclusiveMaximum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMaximum = @5;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMaximum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMaximum = @4;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanGoodTrue
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeBoolean];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@YES  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanGoodFalse
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeBoolean];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@NO  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanBadNumber
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeBoolean];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanBadType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeBoolean];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@"purple"  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByGood
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberDivisbleByBadDivide
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@3  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByBadType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4.5f  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@[]  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@[]  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodMinItems
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.minItems = @2;

    NSArray* array = @[@"one", @"two"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMinItems
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.minItems = @2;

    NSArray* array = @[@"one"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodMaxItems
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.maxItems = @2;

    NSArray* array = @[@"one", @"two"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMaxItems
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.maxItems = @2;

    NSArray* array = @[@"one", @"two", @"three"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodUniqueItems
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.uniqueItems = YES;

    NSArray* array = @[@"one", @"two", @"three"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadUniqueItems
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.uniqueItems = YES;

    NSArray* array = @[@"one", @"two", @"two"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodEnum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"cat", @"bear"];

    NSArray* array = @[@"dog", @"cat"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadEnum
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"bear"];

    NSArray* array = @[@"dog", @"cat"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateObjectGoodType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeObject];

    NSDictionary* object = @{@"color": @"mauve"};

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:object  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateObjectBadType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeObject];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@"mouse"  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNullGoodType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNull];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:[NSNull null]  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNullBadType
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.types = @[JSONSchemaTypeNull];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@0  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateDisallowPass
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.disallowedTypes = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@"fart"  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateDisallowFail
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.disallowedTypes = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@1  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateRequiredPropertyFail
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.properties = @{@"purple" : [JSONSchemaDocument_v3 build:^(JSONSchemaDocument_v3 *schema) {
        schema.required = YES;
    }]};

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@{@"green": @1}
                                       errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateRequiredPropertyPass
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.properties = @{@"purple" : [JSONSchemaDocument_v3 build:^(JSONSchemaDocument_v3 *schema) {
        schema.required = YES;
    }]};

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@{@"purple": @1}
                                       errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidatePropertyTypeFail
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.properties = @{@"purple" : [JSONSchemaDocument_v3 build:^(JSONSchemaDocument_v3 *schema) {
        schema.types = @[JSONSchemaTypeInteger];
    }]};

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@{@"purple": @"hi"}
                                       errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

#pragma mark -

- (void) testMultipleErrorsReturnedForArrayMetaProperties
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 schema];
    schema.maxItems = @2;
    schema.uniqueItems = YES;

    NSArray* array = @[@"one", @"two", @"two"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");

    STAssertTrue([errors count] == 2, @"should be 2 errors");
}

- (void) testMultipleErrorsReturnedForArrayItems
{
    JSONSchemaDocument_v3* schema = [JSONSchemaDocument_v3 build:^(JSONSchemaDocument_v3 *rootSchema) {
        rootSchema.items = [JSONSchemaDocument_v3 build:^(JSONSchemaDocument_v3 *itemSchema) {
            itemSchema.types = @[JSONSchemaTypeInteger];
        }];
    }];

    NSArray* array = @[@"one", @"two"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");

    STAssertTrue([errors count] == 2, @"should be 2 errors");
}

@end

