//
//  JSONSchemaObjectCreationTests.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 1/13/13.
//
//

#import "JSONSchemaObjectCreationTests.h"
#import "JSONSchemaDocument+ObjectCreation.h"

@interface Cat : NSObject

@property (strong, readwrite) NSString *color;

@end

@implementation Cat

@end


@implementation JSONSchemaObjectCreationTests

- (void) testCreateClassWithoutPreviousDefinition
{
    // Set up a basic JSON-Schema for a "Hat" object. It has a single property "color",
    // which is a string and can have the values ("red", "green", "blue").
    
    NSDictionary* schemaDict = @{
        @"title" : @"Hat",
        @"properties" : @{
            @"color" : @{
                @"type": @"string",
                @"enum": @[@"red", @"green", @"blue"]
            }
        }
    };

    NSError* error = nil;
    JSONSchemaDocument* schema = [JSONSchemaDocument JSONSchemaWithObject:schemaDict error:&error];
    XCTAssertNil(error, @"error: %@", error);
    
    // Create an instance of the object defined by the schema
    
    Class cls = [schema registerClass];
    XCTAssertNotNil(cls, @"class is nil");
    id obj = [[cls alloc] init];
    
    // Test set and get valid value
    
    [obj setValue:@"red" forKey:@"color"];
    XCTAssertEqualObjects([obj valueForKey:@"color"], @"red", @"should be red");
    
    // Test set invalid value
    
    XCTAssertThrows([obj setValue:@"purple" forKey:@"color"], @"should throw for invalid value");
}

- (void) testCreateClassWithPreviousDefinition
{
    // Set up a basic JSON-Schema for a "Cat" object. It has a single property "color",
    // which is a string and can have the values ("black", "white", "orange").
    
    // The Cat class is already defined above. This is dynamically associate the JSON-Schema
    // create valdiating setters for properties.
    
    NSDictionary* schemaDict = @{
        @"title" : @"Cat",
        @"properties" : @{
            @"color" : @{
                @"type": @"string",
                @"enum": @[@"black", @"white", @"orange"]
            }
        }
    };
    
    NSError* error = nil;
    JSONSchemaDocument* schema = [JSONSchemaDocument JSONSchemaWithObject:schemaDict error:&error];
    XCTAssertNil(error, @"error: %@", error);
    
    // Create an instance of the object defined by the schema
    
    Class cls = [schema registerClass];
    XCTAssertNotNil(cls, @"class is nil");

    Cat* cat = [[Cat alloc] init];
    
    // Test set and get valid value
    
    cat.color = @"orange";
    
    XCTAssertEqualObjects(cat.color, @"orange", @"should be orange");
    
    // Test set invalid value
    
    XCTAssertThrows([cat setColor:@"purple"], @"should throw for invalid value");
}

- (void) testCreateClassWithNumberProperty
{
    // Set up a basic JSON-Schema for a "Hat" object. It has a single property "color",
    // which is a string and can have the values ("red", "green", "blue").

    NSDictionary* schemaDict = @{
                                 @"title" : @"Pants",
                                 @"properties" : @{
                                         @"size" : @{
                                                 @"type": @"number",
                                                 @"maximum": @3
                                                 }
                                         }
                                 };

    NSError* error = nil;
    JSONSchemaDocument* schema = [JSONSchemaDocument JSONSchemaWithObject:schemaDict error:&error];
    XCTAssertNil(error, @"error: %@", error);

    // Create an instance of the object defined by the schema

    Class cls = [schema registerClass];
    XCTAssertNotNil(cls, @"class is nil");
    id obj = [[cls alloc] init];

    // Test set and get valid value

    [obj setValue:@1 forKey:@"size"];
    XCTAssertEqualObjects([obj valueForKey:@"size"], @1, @"should be 1");

    // Test set invalid value

    XCTAssertThrows([obj setValue:@10 forKey:@"size"], @"should throw for invalid value");
}

@end
