//
//  JSONSchemaObjectContext.m
//  JSONSchema
//
//  Created by Andy Mroczkowski on 6/12/13.
//
//

#import "JSONSchemaObjectContext.h"

@interface JSONSchemaObjectContext ()
@property (nonatomic, retain) NSMutableArray* myArray;
@end

@implementation JSONSchemaObjectContext

- (id)init
{
    self = [super init];
    if (self) {
        self.myArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushContext:(NSString*)contextName
{
    [self.myArray addObject:contextName];
}

- (NSString*)popContext
{
    NSString* contextName = [self.myArray lastObject];
    [self.myArray removeLastObject];
    return contextName;
}



@end
