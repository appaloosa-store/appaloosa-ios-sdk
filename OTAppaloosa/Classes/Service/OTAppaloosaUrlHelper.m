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
//  OTAppaloosaUrlHelper.m
//
//  Created by Cedric Pointel on 06/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaUrlHelper.h"

// Utils
#import "OTAppaloosaUtils.h"

// Fmk
#import "NSString+URLEncoding.h"

const NSString *kBaseUrl = @"https://www.appaloosa-store.com/";

// Authorization
const NSString *kUrlApplicationAuthorization = @"/mobile_application_updates/is_authorized";

// Updates
const NSString *kUrlApplicationUpdates = @"/mobile_application_updates/is_update_needed";

// Application Information
const NSString *kUrlApplicationInformation = @"/mobile_applications/";
const NSString *kUrlApplicationDownload = @"/install";

// Paramaters
const NSString *kUrlTokenParamaterKey = @"token";
const NSString *kUrlApplicationIdParamaterKey = @"application_id";
const NSString *kUrlDeviceIdParamaterKey = @"device_id";
const NSString *kUrlVersionParamaterKey = @"version";
const NSString *kUrlLocaleParamaterKey = @"locale";
const NSString *kUrlJsonExtension = @".json";

@implementation OTAppaloosaUrlHelper

/**************************************************************************************************/
#pragma mark - Authorization

/**
 * This method generates the Appaloosa's URL to check kill switch
 * @param storeId - The store identifier in appaloosa-store.com
 * @param appId - The app id => bundleId
 * @param tokenId - The token identifier in appaloosa-store.com
 *
 *  store_id/mobile_application_updates/is_authorized?
 *      token=(store_token)
 *      &application_id=(bundle_id)
 *      &device_id=(udid_maison)
 *      &version=(app_version)
 *      &locale=(:fr,:en);
 */
+ (NSString *)urlForApplicationAuthorizationWithStoreId:(NSString *)storeId bundleId:(NSString *)bundleId storeToken:(NSString *)storeToken
{
    NSMutableString *url = nil;
    
    if (storeId && bundleId && storeToken)
    {
        NSString *bundleVersion = [OTAppaloosaUtils currentApplicationVersion];
        [bundleVersion stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        url = [NSMutableString stringWithFormat:@"%@%@%@?",kBaseUrl,storeId,kUrlApplicationAuthorization];
        [url appendFormat:@"%@=%@",kUrlTokenParamaterKey,storeToken];
        [url appendFormat:@"&%@=%@",kUrlApplicationIdParamaterKey,bundleId];
        [url appendFormat:@"&%@=%@",kUrlDeviceIdParamaterKey,[OTAppaloosaUtils uniqueDeviceEncoded]];
        [url appendFormat:@"&%@=%@",kUrlVersionParamaterKey,bundleVersion];
        [url appendFormat:@"&%@=%@",kUrlLocaleParamaterKey,locale];
    }
    
    return url;
}

/**************************************************************************************************/
#pragma mark - Application Information

/**
 * This method generates the Appaloosa's URL to get application information
 * @param storeId - The store identifier in appaloosa-store.com
 * @param appId - The app id => bundleId
 * @param tokenId - The token identifier in appaloosa-store.com
 *
 *   store_id/mobile_applications/app_id.json?
 *       token=(store_token)
 */
+ (NSString *)urlForApplicationInformationWithStoreId:(NSString *)storeId bundleId:(NSString *)bundleId storeToken:(NSString *)storeToken
{
    NSMutableString *url = nil;
    
    if (storeId && bundleId && storeToken)
    {
        NSString *bundleIdEncoded = [bundleId urlEncodeUsingEncoding:NSUTF8StringEncoding];
        
        url = [NSMutableString stringWithFormat:@"%@%@%@",kBaseUrl,storeId,kUrlApplicationInformation];
        [url appendFormat:@"%@%@?",bundleIdEncoded,kUrlJsonExtension];
        [url appendFormat:@"%@=%@",kUrlTokenParamaterKey,storeToken];
        [url appendFormat:@"&%@=%@",kUrlDeviceIdParamaterKey,[OTAppaloosaUtils uniqueDeviceEncoded]];
    }
    
    return url;
}

/**************************************************************************************************/
#pragma mark - Application Updates

/**
 * This method generates the Appaloosa's URL to check if an update is available
 * @param storeId - The store identifier in appaloosa-store.com
 * @param appId - The app id => bundleId
 * @param tokenId - The token identifier in appaloosa-store.com
 *
 *  store_id/mobile_application_updates/is_update_needed?
 *      token=(store_token)
 *      &application_id=(bundle_id)
 *      &device_id=(udid_maison)
 *      &version=(app_version)
 *      &locale=(:fr,:en);
 *
 * Result :
 *  { status: UPDATE_NEEDED, download_url: url_a_ouvrir_dans_safari, id: id_de_la_version }
 *
 *  UNREGISTERED_DEVICE
 *  UNKNOWN_APPLICATION
 *  NO_UPDATE_NEEDED
 *  UPDATE_NEEDED
 *  DEVICE_ID_FORMAT_ERROR
 *
 */
+ (NSString *)urlForApplicationUpdateWithStoreId:(NSString *)storeId bundleId:(NSString *)bundleId storeToken:(NSString *)storeToken
{
    NSMutableString *url = nil;
    
    if (storeId && bundleId && storeToken)
    {
        NSString *bundleVersion = [OTAppaloosaUtils currentApplicationVersion];
        [bundleVersion stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        url = [NSMutableString stringWithFormat:@"%@%@%@?",kBaseUrl,storeId,kUrlApplicationUpdates];
        [url appendFormat:@"%@=%@",kUrlTokenParamaterKey,storeToken];
        [url appendFormat:@"&%@=%@",kUrlApplicationIdParamaterKey,bundleId];
        [url appendFormat:@"&%@=%@",kUrlDeviceIdParamaterKey,[OTAppaloosaUtils uniqueDeviceEncoded]];
        [url appendFormat:@"&%@=%@",kUrlVersionParamaterKey,bundleVersion];
    }
    
    return url;
}

/**
 * This method adds parameters to the download url for new application version
 * @param url - The download url retrieved after call `checkUpdates`
 *
 * @see OTAppaloosaAgent # checkUpdates
 */
+ (NSString *)addParamsToDownloadUrl:(NSString *)url
{
    NSMutableString *urlWithParams = nil;
    
    if (url)
    {
        urlWithParams = [NSMutableString stringWithFormat:@"%@?",url];
        [urlWithParams appendFormat:@"%@=%@",kUrlDeviceIdParamaterKey,[OTAppaloosaUtils uniqueDeviceEncoded]];
    }
    
    return urlWithParams;
}

@end
