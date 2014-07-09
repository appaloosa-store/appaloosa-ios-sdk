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
//  OTAppaloosaUtils.m
//
//  Created by Cedric Pointel on 07/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaUtils.h"

#import <Availability.h>

// Fmk
#import <AdSupport/ASIdentifierManager.h>
#import <Base64/MF_Base64Additions.h>
#import "UIDevice+IdentifierAddition.h"
#import "SFHFKeychainUtils.h"

@implementation OTAppaloosaUtils

/**************************************************************************************************/
#pragma mark - AlertView

+ (UIAlertView *)displayAlertWithMessage:(NSString *)message actionTitle:(NSString *)actionTitle withDelegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Appaloosa Information"
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:actionTitle, nil];
    [alert show];
    
    return alert;
}

+ (UIAlertView *)displayAlertWithMessage:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate
{
    return [OTAppaloosaUtils displayAlertWithMessage:message
                                         actionTitle:nil
                                        withDelegate:delegate];
}

+ (UIAlertView *)displayAlertWithMessage:(NSString *)message andActionTitle:(NSString *)actionTitle
{
    return [OTAppaloosaUtils displayAlertWithMessage:message
                                         actionTitle:actionTitle
                                        withDelegate:nil];
}

+ (UIAlertView *)displayAlertWithMessage:(NSString *)message
{
    return [OTAppaloosaUtils displayAlertWithMessage:message
                                         actionTitle:nil
                                        withDelegate:nil];
}

/**************************************************************************************************/
#pragma mark - Utilities

+ (NSString *)uniqueDeviceEncoded
{
    // Check if advertiserId is available (new in iOS 6 only)
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
    NSString *uniqueGlobalDeviceIdentifier = nil;
    if (!NSClassFromString(@"ASIdentifierManager"))
    {
        uniqueGlobalDeviceIdentifier = [[UIDevice currentDevice] uniqueIdentifier];
    }
    else
    {
        uniqueGlobalDeviceIdentifier = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
#else
    NSString *uniqueGlobalDeviceIdentifier = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
#endif
    
    NSString *uniqueGlobalDeviceIdentifierBase64 = [uniqueGlobalDeviceIdentifier base64String];
    return uniqueGlobalDeviceIdentifierBase64;
}

+ (NSString *)currentApplicationVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

/**************************************************************************************************/
#pragma mark - Blacklisting

+ (BOOL)isLocallyBlacklisted
{
    NSString *storedString = [SFHFKeychainUtils getPasswordForUsername:@"appaloosa" andServiceName:@"blacklisting" error:nil];
    if(!storedString)
        return YES;

    return [storedString integerValue];
}

+ (void)setIsLocallyBlacklisted:(BOOL)isBlacklisted
{
    AppaloosaLog(@"Saving blacklist status: %d", isBlacklisted ? 1 : 0);
    [SFHFKeychainUtils deleteItemForUsername:@"appaloosa"
                              andServiceName:@"blacklisting" error:nil];
    [SFHFKeychainUtils storeUsername:@"appaloosa"
                         andPassword:[NSString stringWithFormat:@"%d", isBlacklisted ? 1 : 0]
                      forServiceName:@"blacklisting"
                      updateExisting:YES
                               error:nil];
}

@end
