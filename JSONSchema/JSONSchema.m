//
//  JSONSchema2.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 5/27/13.
//
//

#import "JSONSchema.h"
#import "JSONSchemaDocument_v3.h"

static Class<JSONSchemaSerializationHelper> _JSONSerialization = nil;
static NSMutableDictionary* _DocumentClassByVersion = nil;
static NSInteger _DefaultSchemaVersion = 3;

@implementation JSONSchema

+ (void) initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        // Setup Serialization Helper
        Class cls = NSClassFromString(@"NSJSONSerialization");
        if (cls != nil) {
            [self setSharedJSONSerializationHelper:cls];
        }

        // Register document classes
        _DocumentClassByVersion = [NSMutableDictionary dictionaryWithCapacity:2];
        [self registerDocumentClass:[JSONSchemaDocument_v3 class]];
    });
}

+ (void) setSharedJSONSerializationHelper:(Class<JSONSchemaSerializationHelper>)helper
{
    @synchronized(self) {
        _JSONSerialization = helper;
    }
}

+ (Class<JSONSchemaSerializationHelper>) sharedSerializationHelper
{
    NSParameterAssert(_JSONSerialization);
    return _JSONSerialization;
}

+ (Class) documentClassForSchemaVersion:(NSInteger)version
{
    @synchronized(self) {
        Class cls = _DocumentClassByVersion[[NSNumber numberWithInteger:version]];
        NSAssert(cls, @"No registered document class for schema verion %d", version);
        return cls;
    }
}

+ (void) registerDocumentClass:(Class)cls
{
    @synchronized(self) {
        _DocumentClassByVersion[[NSNumber numberWithInteger:[cls version]]] = cls;
    }
}

+ (NSInteger) defaultSchemaVersion
{
    @synchronized(self) {
        return _DefaultSchemaVersion;
    }
}

+ (void) setDefaultSchemaVersion:(NSInteger)version
{
    @synchronized(self) {
        _DefaultSchemaVersion = version;
    }
}

+ (Class) defaultSchemaDocumentClass
{
    @synchronized(self) {
        return [self documentClassForSchemaVersion:[self defaultSchemaVersion]];
    }
}

@end


