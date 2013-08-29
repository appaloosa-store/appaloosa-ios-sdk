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
//  OTAppaloosaAgentDelegate.h
//
//  Created by Cedric Pointel on 07/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OTApplicationAuthorization.h"

@protocol OTAppaloosaAgentDelegate <NSObject>

@optional

/**************************************************************************************************/
#pragma mark - Application Authorizations Methods Delegate

/**
 * Implement to be inform that the user is authorized to execute the application
 *
 * By default the SDK does nothing.
 *
 */
- (void)applicationAuthorizationsAllowed;

/**
 * Implement to be inform that the user isn't authorized to execute the application
 *
 * By default the SDK shows an alert view with the appropriated message and kills the application.
 * Implement this method if you want your own behaviour.
 *
 * @param status - OTAppaloosaAutorizationsStatus when the device is not allowed to execute the application
 * @param message - Default message to display when the device is not allowed to execute the application
 */
- (void)applicationAuthorizationsNotAllowedWithStatus:(OTAppaloosaAutorizationsStatus)status
                                           andMessage:(NSString *)message;

/**************************************************************************************************/
#pragma mark - Application Updates Methods Delegate

/**
 * Implement to be inform that the application is up to date
 *
 * By default the SDK does nothing.
 *
 */
- (void)applicationIsUpToDate;

/**
 * Implement to be inform that the application has to be updated
 *
 * By default the SDK shows an alert view with the appropriated message and the possibility to download the new version.
 * Implement this method if you want your own behaviour.
 *
 * To download the new version : [[OTAppaloosaAgent sharedAgent] downloadNewVersion];
 *
 */
- (void)applicationIsNotUpToDateWithInstalledVersion:(NSString *)installedVersion
                                 andAppaloosaVersion:(NSString *)appaloosaVersion;

@end
