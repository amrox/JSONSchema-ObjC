//
//  JSONSchemaValidationResult.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 9/29/12.
//
//

#import "JSONSchemaValidationResult.h"

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

- (NSArray*) errors
{
    return self.myErrors;
}

- (BOOL) isValid
{
    return [self.myErrors count] == 0;
}

@end
