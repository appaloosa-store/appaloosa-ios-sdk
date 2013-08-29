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

// Fmk
#import <Base64/MF_Base64Additions.h>
#import "UIDevice+IdentifierAddition.h"

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
    //NSString *uniqueGlobalDeviceIdentifier = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    NSString *uniqueGlobalDeviceIdentifier = [[UIDevice currentDevice] uniqueIdentifier];
    NSString *uniqueGlobalDeviceIdentifierBase64 = [uniqueGlobalDeviceIdentifier base64String];
    return uniqueGlobalDeviceIdentifierBase64;
}

+ (NSString *)currentApplicationVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
