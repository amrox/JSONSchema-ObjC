//
//  JSONSchemaValidationResult.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 9/29/12.
//
//

#import "JSONSchemaValidationResult.h"
#import "JSONSchemaValidationResult+Private.h"

@interface JSONSchemaValidationResult ()
@property (nonatomic, strong) NSMutableArray* myErrors;
@end

@implementation JSONSchemaValidationResult

- (id)init
{
    self = [super init];
    if (self) {
        self.myErrors = [NSMutableArray array];
    }
    return self;
}

+ (id) result
{
    return [[self alloc] init];
}

- (NSArray*) errors
{
    return self.myErrors;
}

- (BOOL) isValid
{
    return [self.myErrors count] == 0;
}

- (void)addError:(NSArray *)error
{
    [self.myErrors addObject:error];
}

- (void)addErrors:(NSArray *)errors
{
    [self.myErrors addObjectsFromArray:errors];
}

- (void)addErrorsFromResult:(JSONSchemaValidationResult *)result
{
    [self addErrors:result.errors];
}

@end
