//
//  JSONSchemaDictionaryRepresentation.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import "JSONSchemaDictionaryRepresentation.h"
#import <objc/runtime.h>


@interface NSArray (JSONSchemaDictionaryRepresentation) <JSONSchemaDictionaryRepresentation>

- (NSDictionary*) jsonSchema_arrayByTransformingValues;

@end


@interface NSDictionary (JSONSchemaDictionaryRepresentation) <JSONSchemaDictionaryRepresentation>

- (NSDictionary*) jsonSchema_dictionaryByTransformingKeysAndValues;

@end



@implementation NSObject (JSONSchemaDictionaryRepresentation)

- (id) jsonSchema_dictionaryByTransformingProperties
{
    unsigned int propertyCount = 0;
    objc_property_t* properties = class_copyPropertyList([self class], &propertyCount);

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:propertyCount];

    for( int i=0; i<propertyCount; i++ ) {
        objc_property_t property = properties[i];
        NSString* propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];

        id transformableSelf = (id<JSONSchemaDictionaryTransformable>)self;

        NSString* key = nil;
        if ([transformableSelf respondsToSelector:@selector(jsonSchema_dictionaryKeyForPropertyName:)]) {
            key = [transformableSelf jsonSchema_dictionaryKeyForPropertyName:propertyName];
        } else {
            key = propertyName;
        }

        id val = [self valueForKey:propertyName];
        if (val != nil) {
            dict[key] = [val jsonSchema_dictionaryRepresentation];
        }
    }

    return dict;
}

- (id) jsonSchema_dictionaryRepresentation
{
    if ([self isKindOfClass:[NSArray class]]) {
        return [(NSArray*)self jsonSchema_arrayByTransformingValues];

    } else if ([self isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary*)self jsonSchema_dictionaryByTransformingKeysAndValues];

    } else if ([self isKindOfClass:[NSString class]]) {
        return self;

    } else if ([self isKindOfClass:[NSNumber class]]) {
        return self;

    } else if ([self conformsToProtocol:@protocol(JSONSchemaDictionaryTransformable)]) {
        return [self jsonSchema_dictionaryByTransformingProperties];
    }

    // TODO: exception?
    NSAssert(NO, @"could not transform object");

    return self;
}

@end



@implementation NSArray (JSONSchemaDictionaryRepresentation)

- (id) jsonSchema_arrayByTransformingValues
{
    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in self) {
        id newObj = [obj jsonSchema_dictionaryRepresentation];
        [newArray addObject:newObj];
    }
    return newArray;
}

@end


@implementation NSDictionary (JSONSchemaDictionaryRepresentation)

- (id) jsonSchema_dictionaryByTransformingKeysAndValues
{
    NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

        id newKey = [key jsonSchema_dictionaryRepresentation];
        id newObj = [obj jsonSchema_dictionaryRepresentation];
        newDict[newKey] = newObj;

    }];
    return newDict;

}

@end