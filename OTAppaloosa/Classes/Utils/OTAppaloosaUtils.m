//
//  OTAppaloosaUtils.m
//  Apploosa-SDK-HOME
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
