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

- (void) testValidateStringOK
{
    NSString* schemaString = @"{\"type\":\"string\"}";
    NSData* schemaData = [schemaString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    JSONSchema* schema = [JSONSchema JSONSchemaWithData:schemaData error:&error];
    STAssertNotNil(schema, @"error: %@", error);
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"errors: %@", errors);
}

- (void) testValidateStringGoodType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
        
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateStringBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
        
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInt:1] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateStringBadMinLength
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    schema.minLength = [NSNumber numberWithInt:10];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"fart" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateStringBadMaxLength
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    schema.maxLength = [NSNumber numberWithInt:2];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"fart" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateStringGoodPattern
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    schema.pattern = @"bo.";
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"boo" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateStringBadPattern
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeString];
    schema.pattern = @"bo.";
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"foo" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodTypeInteger
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];

    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberGoodTypeFloat
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithFloat:5.5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"pineapple" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateIntegerGood
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeInteger];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateIntegerBadFloat
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeInteger];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithFloat:5.5] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}


- (void) testValidateNumberGoodMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.minimum = [NSNumber numberWithInteger:2];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.minimum = [NSNumber numberWithInteger:4];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberGoodExclusiveMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.exclusiveMinimum = [NSNumber numberWithInteger:4];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.exclusiveMinimum = [NSNumber numberWithInteger:4];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberBadMinimum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.minimum = [NSNumber numberWithInteger:5];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.maximum = [NSNumber numberWithInteger:5];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberExactMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.maximum = [NSNumber numberWithInteger:5];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.maximum = [NSNumber numberWithInteger:2];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberGoodExclusiveMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.exclusiveMaximum = [NSNumber numberWithInteger:5];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberBadExclusiveMaximum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.exclusiveMaximum = [NSNumber numberWithInteger:4];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanGoodTrue
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeBoolean];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithBool:YES] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanGoodFalse
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeBoolean];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithBool:NO] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateBooleanBadNumber
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeBoolean];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:5] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateBooleanBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeBoolean];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"purple" againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByGood
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.divisibleBy = [NSNumber numberWithInteger:2];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:4] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateNumberDivisbleByBadDivide
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.divisibleBy = [NSNumber numberWithInteger:2];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInteger:3] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateNumberDivisbleByBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeNumber];
    schema.divisibleBy = [NSNumber numberWithInteger:2];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithFloat:4.5f] againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSArray array] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadType
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
        
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSArray array] againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayGoodMinItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.minItems = [NSNumber numberWithInt:2];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMinItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.minItems = [NSNumber numberWithInt:2];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodMaxItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.maxItems = [NSNumber numberWithInt:2];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadMaxItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.maxItems = [NSNumber numberWithInt:2];
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodUniqueItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.uniqueItems = YES;
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];

    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadUniqueItems
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.uniqueItems = YES;
    
    NSArray* array = [NSArray arrayWithObjects:@"one", @"two", @"two", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateArrayGoodEnum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"cat", @"bear"];

    NSArray* array = [NSArray arrayWithObjects:@"dog", @"cat", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateArrayBadEnum
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.types = [NSArray arrayWithObject:JSONSchemaTypeArray];
    schema.possibleValues = @[@"dog", @"bear"];
    
    NSArray* array = [NSArray arrayWithObjects:@"dog", @"cat", nil];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:array againstSchema:schema errors:&errors];
    STAssertFalse(validationSuccess, @"should fail validation");
}

- (void) testValidateDisallowPass
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.disallowedTypes = [NSArray arrayWithObject:JSONSchemaTypeInteger];

    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:@"fart" againstSchema:schema errors:&errors];
    STAssertTrue(validationSuccess, @"should pass validation");
}

- (void) testValidateDisallowFail
{
    JSONSchema* schema = [JSONSchema JSONSchema];
    schema.disallowedTypes = [NSArray arrayWithObject:JSONSchemaTypeInteger];
    
    NSArray* errors = nil;
    BOOL validationSuccess = [self.logic validate:[NSNumber numberWithInt:1] againstSchema:schema errors:&errors];
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

@end
