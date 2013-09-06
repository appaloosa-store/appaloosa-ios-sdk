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
//  OTApplicationUpdate.m
//  AppaloosaTestFmk
//
//  Created by Cedric Pointel on 04/09/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTApplicationUpdate.h"

const NSString *kApplicationUpdateStatusKey = @"status";
const NSString *kApplicationUpdateDownloadUrlKey = @"download_url";
const NSString *kApplicationUpdateVersionIdKey = @"id";

const NSString *kApplicationUpdateStatusUnregisteredDevice = @"UNREGISTERED_DEVICE";
const NSString *kApplicationUpdateStatusUnknownApplication = @"UNKNOWN_APPLICATION";
const NSString *kApplicationUpdateStatusNoUpdateNeeded = @"NO_UPDATE_NEEDED";
const NSString *kApplicationUpdateStatusUpdateNeeded = @"UPDATE_NEEDED";
const NSString *kApplicationUpdateStatusDeviceIdFormatError = @"DEVICE_ID_FORMAT_ERROR";

@implementation OTApplicationUpdate

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
        
        value = [jsonDict objectForKey:kApplicationUpdateStatusKey];
        if ([value isKindOfClass:[NSString class]])
        {
            _status = [self updateStatusAccordingString:value];
        }
        
        value = [jsonDict objectForKey:kApplicationUpdateDownloadUrlKey];
        if ([value isKindOfClass:[NSString class]])
        {
            _downloadUrl = value;
        }
    
        value = [jsonDict objectForKey:kApplicationUpdateVersionIdKey];
        if ([value isKindOfClass:[NSNumber class]])
        {
            _identifierApplicationVersion = [value stringValue];
        }
    }

    return self;
}

/**************************************************************************************************/
#pragma mark - Utilities

- (OTAppaloosaUpdateStatus)updateStatusAccordingString:(NSString *)statusString
{
    OTAppaloosaUpdateStatus status = OTAppaloosaUpdateStatusNoUpdateNeeded;
    
    if ([statusString isEqualToString:(NSString *)kApplicationUpdateStatusUnregisteredDevice])
        status = OTAppaloosaUpdateStatusUnregisteredDevice;
    else if ([statusString isEqualToString:(NSString *)kApplicationUpdateStatusUnknownApplication])
        status = OTAppaloosaUpdateStatusUnknownApplication;
    else if ([statusString isEqualToString:(NSString *)kApplicationUpdateStatusNoUpdateNeeded])
        status = OTAppaloosaUpdateStatusNoUpdateNeeded;
    else if ([statusString isEqualToString:(NSString *)kApplicationUpdateStatusUpdateNeeded])
        status = OTAppaloosaUpdateStatusUpdateNeeded;
    else if ([statusString isEqualToString:(NSString *)kApplicationUpdateStatusDeviceIdFormatError])
        status = OTAppaloosaUpdateStatusDeviceIdFormatError;
    
    return status;
}

- (NSString *)stringAccordingUpdateStatus
{
    NSString *statusString = nil;
    
    switch (self.status) {
        case OTAppaloosaUpdateStatusUnregisteredDevice:
            statusString = (NSString *)kApplicationUpdateStatusUnregisteredDevice;
            break;
        case OTAppaloosaUpdateStatusUnknownApplication:
            statusString = (NSString *)kApplicationUpdateStatusUnknownApplication;
            break;
        case OTAppaloosaUpdateStatusNoUpdateNeeded:
            statusString = (NSString *)kApplicationUpdateStatusNoUpdateNeeded;
            break;
        case OTAppaloosaUpdateStatusUpdateNeeded:
            statusString = (NSString *)kApplicationUpdateStatusUpdateNeeded;
            break;
        case OTAppaloosaUpdateStatusDeviceIdFormatError:
            statusString = (NSString *)kApplicationUpdateStatusDeviceIdFormatError;
            break;
    }
    
    return statusString;
}

@end
