// Copyright 2012 OCTO Technology
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
//
//  Created by Abdou Benhamouche on 10/12/12.

#import <UIKit/UIKit.h>

#import "OTAppaloosaUpdateService.h"

/**************************************************************************************************/
#pragma mark - Interface

/**
 * AutoUpdate Simple Service.
 *
 * It displays alone an default alertView asking update when available.
 */
@interface OTAppaloosaSimpleUpdateService : OTAppaloosaUpdateService<OTAppaloosaUpdateServiceDelegate, UIAlertViewDelegate>

/**************************************************************************************************/
#pragma mark - Birth & Death

/** @name Birth & Death */

/** Retrieve the common instance of the service */
+ (OTAppaloosaSimpleUpdateService *)sharedInstance DEPRECATED_ATTRIBUTE;

/**************************************************************************************************/
#pragma mark - Manage updates

/** @name Update methods */

/**
 * Call Appaloosa Store Server to check if a new version of the App is available.
 * 
 * @param storeID ID of your Store on Appaloosa Server.
 * @param storeToken Token.
 */
- (void)checkForUpdateWithStoreID:(NSString *)storeID storeToken:(NSString *)storeToken;

@end
