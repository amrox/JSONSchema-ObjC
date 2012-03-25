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


enum 
{
    JSONSCHEMA_ERROR_UNKNOWN                                  = 1001,
    JSONSCHEMA_ERROR_PARSE_FAIL                               = 1002,
    
    JSONSCHEMA_ERROR_NIL_TYPE                                 = 1011,
    JSONSCHEMA_ERROR_INVALID_TYPE                             = 1012,
    JSONSCHEMA_ERROR_ATTRIBUTE_INVALID_TYPE                   = 1013,
    
    JSONSCHEMA_ERROR_VALIDATION_WRONG_TYPE                    = 2011,
    JSONSCHEMA_ERROR_VALIDATION_BAD_VALUE                     = 2012,

};


#define JSERR(E) _JSONSchemaMakeError(E, #E, JSONSCHEMA_ERROR_DOMAIN, nil)
#define JSERR_P(P,E) _JSONSchemaAssignErrorSafe(P,_JSONSchemaMakeError(E, #E, JSONSCHEMA_ERROR_DOMAIN, nil))

#define JSERR_INFO(E,I) _JSONSchemaMakeError(E, #E, JSONSCHEMA_ERROR_DOMAIN, I)
#define JSERR_INFO_P(P,E,I) _JSONSchemaAssignErrorSafe(P,_JSONSchemaMakeError(E, #E, JSONSCHEMA_ERROR_DOMAIN, I))

#define JSERR_REASON(E,R) _JSONSchemaMakeErrorWithReason(E, #E, JSONSCHEMA_ERROR_DOMAIN, R, nil)
#define JSERR_REASON_P(P,E,R) _JSONSchemaAssignErrorSafe(P,_JSONSchemaMakeErrorWithReason(E, #E, JSONSCHEMA_ERROR_DOMAIN, R, nil))

#define JSERR_INFO_REASON(E,I,R) _JSONSchemaMakeErrorWithReason(E, #E, JSONSCHEMA_ERROR_DOMAIN, R, I)
#define JSERR_INFO_REASON_P(P,E,I,R) _JSONSchemaAssignErrorSafe(P,_JSONSchemaMakeErrorWithReason(E, #E, JSONSCHEMA_ERROR_DOMAIN, R, I))


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

static inline NSError* _JSONSchemaMakeErrorWithReason( int errorCode, char const *errorName, NSString* domain, NSString* reason, NSDictionary* userInfo )
{
    if (userInfo == nil) {
        userInfo = [NSDictionary dictionaryWithObject:reason forKey:NSLocalizedFailureReasonErrorKey];
    } else {
        userInfo = [[userInfo mutableCopy] autorelease];
        [(NSMutableDictionary*)userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
    }
    return _JSONSchemaMakeError(errorCode, errorName, domain, userInfo);
}



#endif
