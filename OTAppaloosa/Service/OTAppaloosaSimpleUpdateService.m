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
//  OTAppaloosaSimpleUpdateService.h
//  OTAppaloosaSimpleUpdateService
//
//  Created by Abdou Benhamouche on 10/12/12.
//
//

#import "OTAppaloosaSimpleUpdateService.h"

#import "NSString+URLEncoding.h"

static const NSUInteger kCancelAlert = 0;
static const NSUInteger kOkAlert = 1;

@implementation OTAppaloosaSimpleUpdateService

/**************************************************************************************************/
#pragma mark - Birth & Death

+ (OTAppaloosaSimpleUpdateService *)sharedInstance
{
    static OTAppaloosaSimpleUpdateService *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OTAppaloosaSimpleUpdateService alloc] init];
        sharedInstance.delegate = sharedInstance;
    });
    
    return sharedInstance;
}

/**************************************************************************************************/
#pragma mark - Manage updates

- (void)checkForUpdateWithStoreID:(NSString *)theStoreID storeToken:(NSString *)theStoreToken
{
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    NSString *bundleIDFormatted = [bundle urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    [self checkForUpdateWithStoreID:theStoreID appID:bundleIDFormatted storeToken:theStoreToken];
}

/**************************************************************************************************/
#pragma mark - OTAppaloosaUpdateServiceDelegate

- (void)updateIsAvailableOnAppaloosaStore
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Update available", @"Update available")
                                                    message:NSLocalizedString(@"Would you like to update?", @"Would you like to update?")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"),nil];
    [alert show];
}

/**************************************************************************************************/
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kOkAlert)
    {
        [self downloadNewVersionOfTheApp];
    }
}

@end
