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
//  OTAppaloosaAgent.h
//
//  Created by Cedric Pointel on 06/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "OTAppaloosaAgentDelegate.h"

@interface OTAppaloosaAgent : NSObject <UIAlertViewDelegate>

/**************************************************************************************************/
#pragma mark - Singleton

+ (OTAppaloosaAgent *)sharedAgent;

/**************************************************************************************************/
#pragma mark - Registering

/*
 * This method registers your application in Appaloosa backend.
 * Call this method when the application starts.
 *
 * @param storeId - The store identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param storeToken - The token identifier that you can find in http://www.appaloosa-store.com/settings.
 */
- (void)registerWithStoreId:(NSString*)storeId storeToken:(NSString*)storeToken;

/*
 * This method registers your application in Appaloosa backend.
 * Call this method when the application starts.
 *
 * @param storeId - The store identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param storeToken - The token identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param delegate - The delegate for Appaloosa agent
 */
- (void)registerWithStoreId:(NSString*)storeId storeToken:(NSString*)storeToken andDelegate:(id<OTAppaloosaAgentDelegate>)delegate;


/**************************************************************************************************/
#pragma mark - Check

/*
 * This method checks with Appaloosa backend if the application is authorized to execute the application.
 *   If no internet connection is availabe, the latest status is read from the keychain.
 *
 * Default behaviour :
 * - a success does nothing
 * - a failure displays an alertview to inform the user and the application is closed
 *
 * @see OTAppaloosaAgentDelegate to develop custom behaviour
 *
 */
- (void)checkAuthorizations;

/*
 * This method checks if a new version is available on Appaloosa store
 *
 * Default behaviour :
 * - a success does nothing
 * - a failure displays an alert view in order to propose to the user to download new version
 *
 * @see OTAppaloosaAgentDelegate to develop custom behaviour
 *
 */
- (void)checkUpdates;

/*
 * This method checks if the device is jailbroken
 *  - if it is: alertview and close the app
 *  - if it is not: do nothing
 *
 */
- (void)blockJailbrokenDevice;

/**************************************************************************************************/
#pragma mark - Utilities

/*
 * This method opens Safari to redirect to Appaloosa store in order to download new version
 *
 * @see checkUpdates - Before call this method, it's important to check if an update is available and get the download link
 */
- (void)downloadNewVersion;

/*
 * This method changes the server url contacted by the SDK to enable environment specific requests
 *
 * @param serverBaseURL - The server's url you want the sdk to contact 
 */
- (void)setServerBaseURL:(NSString *)serverBaseURL;

#pragma mark - Getters and Setters

@property (nonatomic) id<OTAppaloosaAgentDelegate> delegate;

/**
 This flag enables logging
 Default: NO
 */
@property (nonatomic, getter = isLogEnabled) BOOL logEnabled;


@end
