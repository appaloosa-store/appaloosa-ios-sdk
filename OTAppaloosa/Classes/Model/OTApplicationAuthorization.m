//
//  OTApplicationAuthorization.m
//  Apploosa-SDK-HOME
//
//  Created by Cedric Pointel on 07/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTApplicationAuthorization.h"

const NSString *kApplicationAuthorizationStatusKey = @"status";
const NSString *kApplicationAuthorizationMessageKey = @"message";

const NSString *kApplicationAuthorizationStatusUnknown = @"UNKNOWN";
const NSString *kApplicationAuthorizationStatusUnknownDevice = @"UNKNOWN_DEVICE";
const NSString *kApplicationAuthorizationStatusUnregisteredDevice = @"UNREGISTERED_DEVICE";
const NSString *kApplicationAuthorizationStatusAuthorized = @"AUTHORIZED";
const NSString *kApplicationAuthorizationStatusNotAuthorized = @"NOT_AUTHORIZED";
const NSString *kApplicationAuthorizationStatusNoNetwork = @"NO_NETWORK";
const NSString *kApplicationAuthorizationStatusRequestError = @"REQUEST_ERROR";

@implementation OTApplicationAuthorization

/**************************************************************************************************/
#pragma mark - Getters and Setters

- (NSString *)message
{
    if (_message == nil)
    {
        return [OTApplicationAuthorization messageAccordingStatus:self.status];
    }
    return _message;
}

/**************************************************************************************************/
#pragma mark - Birth and Death

- (id)initWithJsonDictionary:(NSDictionary *)jsonDict
{
    if (![jsonDict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    if ((self = [super init]))
    {
        id value;
        
        value = [jsonDict objectForKey:kApplicationAuthorizationStatusKey];
        if ([value isKindOfClass:[NSString class]])
        {
            _status = [self authorizationStatusAccordingString:value];
        }
        
        value = [jsonDict objectForKey:kApplicationAuthorizationMessageKey];
        if ([value isKindOfClass:[NSString class]])
        {
            _message = value;
        }
        else
        {
            _message = [OTApplicationAuthorization messageAccordingStatus:_status];
        }
    }
    
    return self;
}

- (OTAppaloosaAutorizationsStatus)authorizationStatusAccordingString:(NSString *)statusString
{
    OTAppaloosaAutorizationsStatus status = OTAppaloosaAutorizationsStatusUnknown;
    
    if ([statusString isEqualToString:(NSString *)kApplicationAuthorizationStatusUnknownDevice])
        status = OTAppaloosaAutorizationsStatusUnknownDevice;
    else if ([statusString isEqualToString:(NSString *)kApplicationAuthorizationStatusUnregisteredDevice])
        status = OTAppaloosaAutorizationsStatusUnregisteredDevice;
    else if ([statusString isEqualToString:(NSString *)kApplicationAuthorizationStatusAuthorized])
        status = OTAppaloosaAutorizationsStatusAuthorized;
    else if ([statusString isEqualToString:(NSString *)kApplicationAuthorizationStatusNotAuthorized])
        status = OTAppaloosaAutorizationsStatusNotAuthorized;
    else if ([statusString isEqualToString:(NSString *)kApplicationAuthorizationStatusNoNetwork])
        status = OTAppaloosaAutorizationsStatusNoNetwork;
    else if ([statusString isEqualToString:(NSString *)kApplicationAuthorizationStatusRequestError])
        status = OTAppaloosaAutorizationsStatusRequestError;
    
    return status;
}

- (NSString *)stringAccordingAuthorizationStatus
{
    NSString *statusString = nil;
    
    switch (self.status) {
        case OTAppaloosaAutorizationsStatusUnknown:
            statusString = (NSString *)kApplicationAuthorizationStatusUnknown;
            break;
        case OTAppaloosaAutorizationsStatusUnknownDevice:
            statusString = (NSString *)kApplicationAuthorizationStatusUnknownDevice;
        break;
        case OTAppaloosaAutorizationsStatusUnregisteredDevice:
            statusString = (NSString *)kApplicationAuthorizationStatusUnregisteredDevice;
        break;
        case OTAppaloosaAutorizationsStatusAuthorized:
            statusString = (NSString *)kApplicationAuthorizationStatusAuthorized;
        break;
        case OTAppaloosaAutorizationsStatusNotAuthorized:
            statusString = (NSString *)kApplicationAuthorizationStatusNotAuthorized;
        break;
        case OTAppaloosaAutorizationsStatusNoNetwork:
            statusString = (NSString *)kApplicationAuthorizationStatusNoNetwork;
        break;
        case OTAppaloosaAutorizationsStatusRequestError:
            statusString = (NSString *)kApplicationAuthorizationStatusRequestError;
        break;
    }
    
    return statusString;
}

+ (NSString *)messageAccordingStatus:(OTAppaloosaAutorizationsStatus)status
{
    NSString *message = nil;
    
    switch (status)
    {
        case OTAppaloosaAutorizationsStatusNoNetwork:
            message = @"Veuillez vérifier votre connection Internet, merci.";
            break;
        case OTAppaloosaAutorizationsStatusUnknown:
        case OTAppaloosaAutorizationsStatusRequestError:            
            message = @"Une erreur est survenue. Veuillez réessayer ultérieusement.";
            break;
        default:
            break;
    }
    
    return message;
}

@end
