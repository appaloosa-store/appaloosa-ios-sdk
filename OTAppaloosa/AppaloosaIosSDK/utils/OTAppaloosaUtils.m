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
#import "MF_Base64Additions.h"
#import "UIDevice+IdentifierAddition.h"
#import "BCCKeychain.h"

@implementation OTAppaloosaUtils

/**************************************************************************************************/
#pragma mark - AlertView

+ (UIAlertController *)displayAlertWithMessage:(NSString *)message actionTitle:(NSString *)actionTitle withAction:(NSUInteger)alertState
{
    NSString *cancelMessage = NSLocalizedString(@"Cancel", @"Cancel");
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"Appaloosa Information", @"Appaloosa Information")
                                message:message
                                preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:cancelMessage
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [OTAppaloosaUtils buttonIsClicked:alertState];
                                   }];
    [alert addAction:cancelAction];
    return alert;
}

+ (UIAlertController *)displayAlertWithMessage:(NSString *)message withAction:(NSUInteger)alertState
{
    
    return [OTAppaloosaUtils displayAlertWithMessage:message
                                         actionTitle:nil
                                          withAction:alertState];
}

+ (UIAlertController *)displayAlertWithMessage:(NSString *)message
{
    return [OTAppaloosaUtils displayAlertWithMessage:message
                                         actionTitle:nil
                                          withAction:kAlertViewApplicationNone];
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

+ (void)buttonIsClicked:(NSUInteger)typeAlertView
{
    switch (typeAlertView)
    {
        case kAlertViewApplicationAuthorization:
        case kAlertViewApplicationJailbreak:
        {
            exit(0);
            break;
        }
        default:
            break;
    }
}

/**************************************************************************************************/
#pragma mark - Blacklisting

+ (BOOL)isLocallyBlacklisted
{
    
    NSString *storedString = [BCCKeychain getPasswordStringForUsername:@"appaloosa" andServiceName:@"blacklisting" error:nil];
    if(!storedString) {
        AppaloosaLog(@"Keychain does not exist => first launch");
        return NO;
    }

    return [storedString integerValue];
}

+ (void)setIsLocallyBlacklisted:(BOOL)isBlacklisted
{
    AppaloosaLog(@"Saving blacklist status: %d", isBlacklisted ? 1 : 0);
    [BCCKeychain deleteItemForUsername:@"appaloosa"
                              andServiceName:@"blacklisting" error:nil];
    
    [BCCKeychain storeUsername:@"appaloosa" andPasswordString:[NSString stringWithFormat:@"%d", isBlacklisted ? 1 : 0] forServiceName:@"blacklisting" updateExisting:YES error:nil];
}

/**************************************************************************************************/
#pragma mark - Analytics

+ (void)storeAnalyticsEndpoint:(NSString *)endpoint {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

    [preferences setObject:endpoint forKey:@"analyticsEndpoint"];
}

+ (void)refreshAnalyticsEndpoint {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [OTAppaloosaUtils storeAnalyticsEndpoint:[preferences objectForKey:@"analyticsEndpoint"]];
}

/**************************************************************************************************/
#pragma mark - Jailbreak

+ (OTApplicationAuthorization *)checkDeviceJailbreak
{
    OTApplicationAuthorization *appAuthorization = [[OTApplicationAuthorization alloc] init];
    appAuthorization.status = OTAppaloosaAutorizationsStatusJailbroken;

#if !(TARGET_IPHONE_SIMULATOR)
    FILE *file = fopen("/bin/bash", "r");
    BOOL fileIsNull = errno == ENOENT;
    fclose(file);

    if(!fileIsNull || [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]])
        return appAuthorization;
#endif

    appAuthorization.status = OTAppaloosaAutorizationsStatusAuthorized;
    return appAuthorization;
}
@end
