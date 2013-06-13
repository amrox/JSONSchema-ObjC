//
//  JSONSchemaErrors.h
//  JSONSchema
//
//  Created by Andy Mroczkowski on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef JSONSchema_JSONSchemaErrors_h
#define JSONSchema_JSONSchemaErrors_h

#define JSONSCHEMA_ERROR_DOMAIN @"net.mrox.JSONSchema"

#define JSONSchemaErrorLocationKey @"JSONSchemaErrorLocationKey"

enum 
{
    JSONSCHEMA_ERROR_UNKNOWN                                  = 1001,
    JSONSCHEMA_ERROR_PARSE_FAIL                               = 1002,
    
    JSONSCHEMA_ERROR_NIL_TYPE                                 = 1011,
    JSONSCHEMA_ERROR_INVALID_TYPE                             = 1012,
    JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE                   = 1013,
    JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_VALUE                  = 1014,

    JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE                    = 2011,
    JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE                     = 2012,
    JSONSCHEMA_ERROR_VALIDATION_MISSING_VALUE                 = 2013,
};


#define JSERR(E,R) _JSONSchemaMakeErrorWithReason(E, #E, JSONSCHEMA_ERROR_DOMAIN, R, nil, nil)
#define JSERR_P(P,E,R) _JSONSchemaAssignErrorSafe(P,_JSONSchemaMakeErrorWithReason(E, #E, JSONSCHEMA_ERROR_DOMAIN, R, nil, nil))

#define JSERR2(E,R,C) _JSONSchemaMakeErrorWithReason(E, #E, JSONSCHEMA_ERROR_DOMAIN, R, C, nil)
#define JSERR_P2(P,E,R,C) _JSONSchemaAssignErrorSafe(P,_JSONSchemaMakeErrorWithReason(E, #E, JSONSCHEMA_ERROR_DOMAIN, R, C, nil))


static inline void _JSONSchemaAssignErrorSafe( NSError** outError, NSError* error )
{
    if( outError != nil ) *outError = error;
}

static inline NSError* _JSONSchemaMakeError( int errorCode, char const *errorName, NSString* domain, NSDictionary *userInfo )
{
    NSString *errorNameString = [NSString stringWithCString:errorName encoding:NSUTF8StringEncoding];
    
    NSString *localizedDescription = [[NSBundle mainBundle] localizedStringForKey:errorNameString
                                                                            value:errorNameString
                                                                            table:@"Errors"];
    
    NSMutableDictionary *dict;
    if( userInfo != nil ) {
        dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    } else {
        dict = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    [dict setValue:errorNameString forKey:@"ErrorName"];
    [dict setValue:localizedDescription forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:domain code:errorCode userInfo:dict];
}

static inline NSError* _JSONSchemaMakeErrorWithReason( int errorCode, char const *errorName, NSString* domain, NSString* reason, id context, NSDictionary* userInfo )
{
    NSMutableDictionary *tmpUserInfo = nil;

    if (userInfo == nil) {
        tmpUserInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    } else {
        tmpUserInfo = [userInfo mutableCopy];
    }

    if (reason != nil) {
        tmpUserInfo[NSLocalizedFailureReasonErrorKey] = reason;
    }
    if (context != nil) {
        tmpUserInfo[JSONSchemaErrorLocationKey] = [context description];
    }

    return _JSONSchemaMakeError(errorCode, errorName, domain, tmpUserInfo);
}



#endif
