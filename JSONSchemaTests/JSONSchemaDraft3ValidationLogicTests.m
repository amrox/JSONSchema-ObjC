//
//  JSONValidationContextTests.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONSchemaDraft3ValidationLogicTests.h"
#import "TestUtility.h"
#import "JSONSchemaDraft3.h"
#import "JSONSchemaDraft3ValidationLogic.h"
#import "JSONSchemaValidationResult.h"

@interface JSONSchemaDraft3ValidationLogicTests ()


@end

@implementation JSONSchemaDraft3ValidationLogicTests

- (void) testLoadSchemaFromString
{
    NSString* schemaString = @"{\"type\":\"string\"}";
    NSData* schemaData = [schemaString dataUsingEncoding:NSUTF8StringEncoding];

    NSError* error = nil;
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 JSONSchemaWithData:schemaData error:&error];
    STAssertNotNil(schema, @"error: %@", error);
}

- (void) testValidateStringOK
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];

    JSONSchemaValidationResult* result = [schema validate:@"fart"];
    STAssertTrue([result isValid], @"errors: %@", result.errors);
}

- (void) testValidateStringGoodType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];

    JSONSchemaValidationResult* result =  [schema validate:@"fart"];
    STAssertTrue([result isValid], @"errors: %@", result.errors);
}

- (void) testValidateStringBadType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];

    JSONSchemaValidationResult* result = [schema validate:@1];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringBadMinLength
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.minLength = @10;

    JSONSchemaValidationResult* result = [schema validate:@"fart"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringBadMaxLength
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.maxLength = @2;

    JSONSchemaValidationResult* result = [schema validate:@"fart"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringGoodPattern
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.pattern = @"bo.";

    JSONSchemaValidationResult* result = [schema validate:@"boo"];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateStringBadPattern
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.pattern = @"bo.";

    JSONSchemaValidationResult* result =  [schema validate:@"foo"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringGoodEnum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.possibleValues = @[@"dog", @"cat"];

    JSONSchemaValidationResult* result = [schema validate:@"dog"];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateStringBadEnum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeString];
    schema.possibleValues = @[@"dog", @"cat"];

    JSONSchemaValidationResult* result = [schema validate:@"walrus"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateNumberGoodTypeInteger
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];

    JSONSchemaValidationResult* result = [schema validate:@5];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateNumberGoodTypeFloat
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];

    JSONSchemaValidationResult* result = [schema validate:@5.5f];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateNumberBadType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];

    JSONSchemaValidationResult* result = [schema validate:@"pineapple"];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateIntegerGood
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateIntegerBadFloat
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5.5f errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}


- (void) testValidateNumberGoodMinimum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMinimum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @4;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberGoodExclusiveMinimum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMinimum = @4;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMinimum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMinimum = @4;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberBadMinimum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @5;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodMaximum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @5;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMaximum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @5;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadMaximum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodExclusiveMaximum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMaximum = @5;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMaximum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMaximum = @4;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4 errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanGoodTrue
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeBoolean];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@YES  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanGoodFalse
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeBoolean];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@NO  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanBadNumber
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeBoolean];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@5  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanBadType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeBoolean];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@"purple"  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByGood
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberDivisbleByBadDivide
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@3  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByBadType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@4.5f  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@[]  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@[]  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodMinItems
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.minItems = @2;

    NSArray* array = @[@"one", @"two"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMinItems
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.minItems = @2;

    NSArray* array = @[@"one"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodMaxItems
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.maxItems = @2;

    NSArray* array = @[@"one", @"two"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMaxItems
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.maxItems = @2;

    NSArray* array = @[@"one", @"two", @"three"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodUniqueItems
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.uniqueItems = YES;

    NSArray* array = @[@"one", @"two", @"three"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadUniqueItems
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.uniqueItems = YES;

    NSArray* array = @[@"one", @"two", @"two"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodEnum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"cat", @"bear"];

    NSArray* array = @[@"dog", @"cat"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadEnum
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"bear"];

    NSArray* array = @[@"dog", @"cat"];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:array  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateObjectGoodType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeObject];

    NSDictionary* object = @{@"color": @"mauve"};

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:object  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateObjectBadType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeObject];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@"mouse"  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNullGoodType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNull];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:[NSNull null]  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNullBadType
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.types = @[JSONSchemaTypeNull];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@0  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateDisallowPass
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.disallowedTypes = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@"fart"  errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateDisallowFail
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.disallowedTypes = @[JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@1  errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateRequiredPropertyFail
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.properties = @{@"purple" : [JSONSchemaDraft3 build:^(JSONSchemaDraft3 *schema) {
        schema.required = YES;
    }]};

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@{@"green": @1}
                                       errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateRequiredPropertyPass
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.properties = @{@"purple" : [JSONSchemaDraft3 build:^(JSONSchemaDraft3 *schema) {
        schema.required = YES;
    }]};

    NSArray* errors = nil;
    BOOL validationSuccess = [schema validate:@{@"purple": @1}
                                       errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidatePropertyTypeFail
{
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
    schema.properties = @{@"purple" : [JSONSchemaDraft3 build:^(JSONSchemaDraft3 *schema) {
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
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 schema];
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
    JSONSchemaDraft3* schema = [JSONSchemaDraft3 build:^(JSONSchemaDraft3 *rootSchema) {
        rootSchema.items = [JSONSchemaDraft3 build:^(JSONSchemaDraft3 *itemSchema) {
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

