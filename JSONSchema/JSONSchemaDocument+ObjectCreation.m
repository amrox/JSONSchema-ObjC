//
//  JSONSchema+ObjectCreation.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 1/12/13.
//
//

#import "JSONSchemaDocument+ObjectCreation.h"
#import <objc/runtime.h>
#import "JSONSchemaDocument.h"
#import "JSONSchemaValidationResult.h"
#import "JSONSchemaInternal.h"


@implementation NSObject (JSONSchema)

- (JSONSchemaDocument *) JSONSchemaDocument
{
    JSONSchemaDocument *schema = objc_getAssociatedObject([self class], "JSONSchemaDocument");
    return schema;
}

@end


#pragma mark Utility Methods

static NSString* defaultInstanceVariableNameForPropertyName(NSString* propertyName)
{
    return [@"_" stringByAppendingString:propertyName];
}

static NSString* instanceVariableNameForPropertyName(Class cls, NSString* propertyName)
{
    objc_property_t property = class_getProperty(cls, [propertyName UTF8String]);
    
    unsigned int propertyAttrCount;
    objc_property_attribute_t* propertyAttrs = property_copyAttributeList(property, &propertyAttrCount);
    
    NSString* ivarName = nil;
    
    for (unsigned int i = 0; i < propertyAttrCount && ivarName == nil; i++) {
        const char* name = propertyAttrs[i].name;
        if (strncmp(name, "V", 1) == 0) {
            const char* val = propertyAttrs[i].value;
            ivarName = [NSString stringWithCString:val encoding:NSUTF8StringEncoding];
        }
    }
    
    return ivarName;
}

@implementation JSONSchemaDocument (ObjectCreation)

- (IMP) getterImpForPropertyName:(NSString*)propertyName instanceVariableName:(NSString*)instanceVariableName
{
    return imp_implementationWithBlock(^(id _self) {
        Ivar ivar = class_getInstanceVariable([_self class], [instanceVariableName UTF8String]);
        return object_getIvar(_self, ivar);
    });
}

- (IMP) setterImpForPropertyName:(NSString*)propertyName instanceVariableName:(NSString*)instanceVariableName
{
    return imp_implementationWithBlock(^(id _self, id val) {
        
        NSAssert([_self JSONSchemaDocument], @"No JSON Schema found.");
        
        JSONSchemaDocument* propertySchema = [_self JSONSchemaDocument].properties[propertyName];
        if (propertySchema) {
            JSONSchemaValidationResult* result = [propertySchema
                                                  validate:val];
            if (![result isValid]) {
                [NSException raise:NSInvalidArgumentException format:@"%@", [result errors]];
            }
        }
        
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

- (Class) registerClass
{
    NSAssert(self.title, @"Missing 'title' attribute");
    return [self registerClassWithName:self.title];
}

- (Class) registerClassWithName:(NSString*)className
{
    Class cls = NSClassFromString(className);
    if (cls == nil) {
        cls = objc_allocateClassPair([NSObject class], [className UTF8String], 0);
        
        [self.properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            NSString* propertyName = key;
            JSONSchemaDocument* propertySchema = obj;
            
            if ([propertySchema.types count] > 1) {
                
                AssertNYI();
                
            } else {
                
                id type = [propertySchema.types objectAtIndex:0];

                NSString* ivarName = defaultInstanceVariableNameForPropertyName(propertyName);

                char *ivarEncoding = @encode(NSString);
                NSUInteger ivarSize, ivarAlign;
                NSGetSizeAndAlignment(ivarEncoding, &ivarSize, &ivarAlign);

                if (!class_addIvar(cls, [ivarName UTF8String], ivarSize, ivarAlign, ivarEncoding)) {
                    abort(); // TODO: throw an exception or try a different ivar
                }

                if ([type isEqual:JSONSchemaTypeString]) {

                    objc_property_attribute_t type = { "T", "@\"NSString\"" };
                    objc_property_attribute_t ownership = { "C", "" }; // C = copy
                    objc_property_attribute_t backingivar  = { "V", [ivarName UTF8String] };
                    
                    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
                    class_addProperty(cls, [propertyName UTF8String], attrs, 3);

                } else if ([type isEqual:JSONSchemaTypeNumber]) {

                    objc_property_attribute_t type = { "T", "@\"NSNumber\"" };
                    objc_property_attribute_t ownership = { "R", "" }; 
                    objc_property_attribute_t backingivar  = { "V", [ivarName UTF8String] };

                    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
                    class_addProperty(cls, [propertyName UTF8String], attrs, 3);

                } else {
                    AssertNYI();
                }

                SEL getterSel = [self getterSelectorForPropertyName:propertyName];
                SEL setterSel = [self setterSelectorForPropertyName:propertyName];
                IMP getterImp = [self getterImpForPropertyName:propertyName instanceVariableName:ivarName];
                IMP setterImp = [self setterImpForPropertyName:propertyName instanceVariableName:ivarName];

                class_replaceMethod(cls, getterSel, getterImp, "@@:");
                class_replaceMethod(cls, setterSel, setterImp, "v@:@");

            }
        }];

        objc_registerClassPair(cls);
    
    } else {
        
        [self.properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            NSString* propertyName = key;
            JSONSchemaDocument* propertySchema = obj;
            
            if ([propertySchema.types count] > 1) {
                
                AssertNYI();

            } else {
                
                NSString* ivarName = instanceVariableNameForPropertyName(cls, propertyName);
                
                SEL getterSel = [self getterSelectorForPropertyName:propertyName];
                SEL setterSel = [self setterSelectorForPropertyName:propertyName];
                IMP getterImp = [self getterImpForPropertyName:propertyName instanceVariableName:ivarName];
                IMP setterImp = [self setterImpForPropertyName:propertyName instanceVariableName:ivarName];
                
                class_replaceMethod(cls, getterSel, getterImp, "@@:");
                class_replaceMethod(cls, setterSel, setterImp, "v@:@");
            }
        }];
    }
    
    objc_setAssociatedObject(cls, "JSONSchemaDocument", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return cls;
}

@end
