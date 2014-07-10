// Copyright 2013 OCTO Technology
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  OTApplicationAuthorization.m
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
const NSString *kApplicationAuthorizationStatusJailbroken = @"JAILBROKEN_DEVICE";

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

/**************************************************************************************************/
#pragma mark - Utilities

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
    else if ([statusString isEqualToString:(NSString *)kApplicationAuthorizationStatusJailbroken])
        status = OTAppaloosaAutorizationsStatusJailbroken;
    
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
        case OTAppaloosaAutorizationsStatusJailbroken:
            statusString = (NSString *)kApplicationAuthorizationStatusJailbroken;
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
        case OTAppaloosaAutorizationsStatusJailbroken:
            message = @"Vous ne pouvez pas utiliser cette app sur votre téléphone jailbreaké.";
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
