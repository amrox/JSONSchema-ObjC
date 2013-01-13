//
//  JSONSchema+ObjectCreation.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 1/12/13.
//
//

#import "JSONSchema+ObjectCreation.h"
#import <objc/runtime.h>
#import "JSONSchema.h"
#import "JSONSchemaValidationLogic.h"
#import "JSONSchemaValidationResult.h"

@interface _JSONSchemaValidatingObject : NSObject

@property (strong, readwrite) JSONSchema* schema;

@end

@implementation _JSONSchemaValidatingObject

- (id)initWithJSONSchema:(JSONSchema*)schema
{
    self = [super init];
    if (self) {
        self.schema = schema;
    }
    return self;
}

@end

#pragma mark Utility Methods

static NSString* instanceVariableNameForPropertyName(NSString* propertyName)
{
    return [@"_" stringByAppendingString:propertyName];
}


@implementation JSONSchema (ObjectCreation)


- (IMP) getterImpForPropertyName:(NSString*)propertyName
{
    return imp_implementationWithBlock(^(id _self) {
        NSString* instanceVariableName = instanceVariableNameForPropertyName(propertyName);
        Ivar ivar = class_getInstanceVariable([_self class], [instanceVariableName UTF8String]);
        return object_getIvar(_self, ivar);
    });
}

- (IMP) propertySetterImpForInstanceVariableName:(NSString*)propertyName
{
    return imp_implementationWithBlock(^(id _self, id val) {
        
        _JSONSchemaValidatingObject* _validatingSelf = (_JSONSchemaValidatingObject*)_self;
        JSONSchema* propertySchema = _validatingSelf.schema.properties[propertyName];
        if (propertySchema) {
            JSONSchemaValidationResult* result = [[JSONSchemaValidationLogic defaultValidationLogic]
                                                  validate:val againstSchema:propertySchema];
            if (![result isValid]) {
                [NSException raise:NSInvalidArgumentException format:@"%@", [result errors]];
            }
        }
        
        NSString* instanceVariableName = instanceVariableNameForPropertyName(propertyName);
        Ivar ivar = class_getInstanceVariable([_self class], [instanceVariableName UTF8String]);
        object_setIvar(_self, ivar, val);
    });
}

- (SEL) getterSelectorForPropertyName:(NSString*)propertyName
{
    return NSSelectorFromString(propertyName);
}

- (SEL) setterSelectorForPropertyName:(NSString*)propertyName
{
    NSString* selname = [NSString stringWithFormat:@"set%@:",
                         [[[propertyName substringToIndex:1] uppercaseString]
                          stringByAppendingString:[propertyName substringFromIndex:1]]];
    return NSSelectorFromString(selname);
}

- (id) createObject
{
    NSString* className = self.title;
    Class cls = NSClassFromString(className);
    if (cls == nil) {
        cls = objc_allocateClassPair([_JSONSchemaValidatingObject class], [className UTF8String], 0);
        
        [self.properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString* propertyName = key;
            JSONSchema* propertySchema = obj;
            

            if ([propertySchema.types count] > 1) {
                
                abort();
                
            } else {
                
                id type = [propertySchema.types objectAtIndex:0];
                
                if ([type isEqual:JSONSchemaTypeString]) {
                    
                    NSString* ivarName = instanceVariableNameForPropertyName(propertyName);
                    
                    char *ivarEncoding = @encode(NSString);
                    NSUInteger ivarSize, ivarAlign;
                    NSGetSizeAndAlignment(ivarEncoding, &ivarSize, &ivarAlign);
                    
                    if (!class_addIvar(cls, [ivarName UTF8String], ivarSize, ivarAlign, ivarEncoding)) {
                        abort();
                    }
                    
                    objc_property_attribute_t type = { "T", "@\"NSString\"" };
                    objc_property_attribute_t ownership = { "C", "" }; // C = copy
                    objc_property_attribute_t backingivar  = { "V", [ivarName UTF8String] };
                    
                    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
                    class_addProperty(cls, [propertyName UTF8String], attrs, 3);

                    IMP getter = [self getterImpForPropertyName:propertyName];
                    IMP setter = [self propertySetterImpForInstanceVariableName:propertyName];
                    
                    class_addMethod(cls, [self getterSelectorForPropertyName:propertyName], (IMP)getter, "@@:");
                    class_addMethod(cls, [self setterSelectorForPropertyName:propertyName], (IMP)setter, "v@:@");
                    
                } else {
                    abort();
                }
            }
        }];
        
        objc_registerClassPair(cls);
    }
    
    return [[cls alloc] initWithJSONSchema:self];
}

@end
