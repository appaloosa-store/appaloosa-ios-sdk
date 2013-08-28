//
//  OTAppaloosaUtils.h
//  Apploosa-SDK-HOME
//
//  Created by Cedric Pointel on 07/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaAgent.h"

#import <Foundation/Foundation.h>

#define AppaloosaLog(fmt, ...) if([OTAppaloosaAgent sharedAgent].isLogEnabled) { NSLog((@"[AppaloosaSDK] " fmt), ##__VA_ARGS__); }

@interface OTAppaloosaUtils : NSObject

/**************************************************************************************************/
#pragma mark - AlertView

+ (UIAlertView *)displayAlertWithMessage:(NSString *)message actionTitle:(NSString *)actionTitle withDelegate:(id<UIAlertViewDelegate>)delegate;
+ (UIAlertView *)displayAlertWithMessage:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate;
+ (UIAlertView *)displayAlertWithMessage:(NSString *)message andActionTitle:(NSString *)actionTitle;
+ (UIAlertView *)displayAlertWithMessage:(NSString *)message;

/**************************************************************************************************/
#pragma mark - Utilities

+ (NSString *)uniqueDeviceEncoded;
+ (NSString *)currentApplicationVersion;

@end
