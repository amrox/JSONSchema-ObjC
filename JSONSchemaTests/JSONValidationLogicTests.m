//
//  JSONValidationContextTests.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONValidationLogicTests.h"
#import "TestUtility.h"
#import "JSONSchema.h"
#import "JSONSchemaValidationLogic.h"
#import "JSONSchemaValidationResult.h"

@interface JSONValidationLogicTests ()

@property (nonatomic, strong) JSONSchemaValidationLogic *logic;

@end

@implementation JSONValidationLogicTests

- (void) setUp
{
    self.logic = [JSONSchemaValidationLogic defaultValidationLogic];
}

- (void) tearDown
{
    self.logic = nil;
}

- (void) testLoadSchemaFromString
{
    NSString* schemaString = @"{\"type\":\"string\"}";
    NSData* schemaData = [schemaString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    JSONSchema* schema = [JSONSchema JSONSchemaWithData:schemaData error:&error];
    STAssertNotNil(schema, @"error: %@", error);
}

- (void) testValidateStringOK
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeString];

    JSONSchemaValidationResult* result = [self.logic validate:@"fart" againstSchema:schema];
    STAssertTrue([result isValid], @"errors: %@", result.errors);
}

- (void) testValidateStringGoodType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeString];
    
    JSONSchemaValidationResult* result =  [self.logic validate:@"fart" againstSchema:schema];
    STAssertTrue([result isValid], @"errors: %@", result.errors);
}

- (void) testValidateStringBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeString];
    
    JSONSchemaValidationResult* result = [self.logic validate:@1 againstSchema:schema];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringBadMinLength
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeString];
    schema.minLength = @10;
    
    JSONSchemaValidationResult* result = [self.logic validate:@"fart" againstSchema:schema];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringBadMaxLength
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeString];
    schema.maxLength = @2;
    
    JSONSchemaValidationResult* result = [self.logic validate:@"fart" againstSchema:schema];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateStringGoodPattern
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeString];
    schema.pattern = @"bo.";
    
    JSONSchemaValidationResult* result = [self.logic validate:@"boo" againstSchema:schema];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateStringBadPattern
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeString];
    schema.pattern = @"bo.";
    
    JSONSchemaValidationResult* result =  [self.logic validate:@"foo" againstSchema:schema];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateNumberGoodTypeInteger
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    
    JSONSchemaValidationResult* result = [self.logic validate:@5 againstSchema:schema];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateNumberGoodTypeFloat
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    
    JSONSchemaValidationResult* result = [self.logic validate:@5.5f againstSchema:schema];
    STAssertTrue([result isValid], @"should pass validation");
}

- (void) testValidateNumberBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    
    JSONSchemaValidationResult* result = [self.logic validate:@"pineapple" againstSchema:schema];
    STAssertFalse([result isValid], @"should fail validation");
}

- (void) testValidateIntegerGood
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeInteger];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@5 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateIntegerBadFloat
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeInteger];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@5.5f againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}


- (void) testValidateNumberGoodMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @2;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @4;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberGoodExclusiveMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMinimum = @4;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@5 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMinimum = @4;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberBadMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.minimum = @5;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @5;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @5;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@5 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.maximum = @2;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodExclusiveMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMaximum = @5;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.exclusiveMaximum = @4;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanGoodTrue
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeBoolean];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@YES againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanGoodFalse
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeBoolean];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@NO againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanBadNumber
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeBoolean];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@5 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeBoolean];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"purple" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByGood
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4 againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberDivisbleByBadDivide
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@3 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeNumber];
    schema.divisibleBy = @2;
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@4.5f againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@[] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeInteger];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@[] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodMinItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    schema.minItems = @2;
    
    NSArray* array = @[@"one", @"two"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMinItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    schema.minItems = @2;
    
    NSArray* array = @[@"one"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodMaxItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    schema.maxItems = @2;
    
    NSArray* array = @[@"one", @"two"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMaxItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    schema.maxItems = @2;
    
    NSArray* array = @[@"one", @"two", @"three"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodUniqueItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    schema.uniqueItems = YES;
    
    NSArray* array = @[@"one", @"two", @"three"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadUniqueItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    schema.uniqueItems = YES;
    
    NSArray* array = @[@"one", @"two", @"two"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodEnum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"cat", @"bear"];
    
    NSArray* array = @[@"dog", @"cat"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadEnum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = @[JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"bear"];
    
    NSArray* array = @[@"dog", @"cat"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateDisallowPass
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.disallowedTypes = @[JSONSchemaTypeInteger];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateDisallowFail
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.disallowedTypes = @[JSONSchemaTypeInteger];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@1 againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateRequiredPropertyFail
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.properties = @{@"purple" : [JSONSchema build:^(JSONSchema *schema) {
        schema.required = YES;
    }]};
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@{@"green": @1}
                                    againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateRequiredPropertyPass
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.properties = @{@"purple" : [JSONSchema build:^(JSONSchema *schema) {
        schema.required = YES;
    }]};
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@{@"purple": @1}
                                    againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidatePropertyTypeFail
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.properties = @{@"purple" : [JSONSchema build:^(JSONSchema *schema) {
        schema.types = @[JSONSchemaTypeInteger];
    }]};
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@{@"purple": @"hi"}
                                    againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

#pragma mark -

- (void) testMultipleErrorsReturnedForArrayMetaProperties
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.maxItems = @2;
    schema.uniqueItems = YES;
    
    NSArray* array = @[@"one", @"two", @"two"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
    
    STAssertTrue([errors count] == 2, @"should be 2 errors");
}

- (void) testMultipleErrorsReturnedForArrayItems
{
    JSONSchema* schema = [JSONSchema build:^(JSONSchema *rootSchema) {
        rootSchema.items = [JSONSchema build:^(JSONSchema *itemSchema) {
            itemSchema.types = @[JSONSchemaTypeInteger];
        }];
    }];
    
    NSArray* array = @[@"one", @"two"];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
    
    STAssertTrue([errors count] == 2, @"should be 2 errors");
}

@end
