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

#import "OTAppaloosaAgentDelegate.h"

// Manager
#import "OTAppaloosaActionButtonsManager.h"

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
 * This method checks if the application is authorized to be executed
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

/**************************************************************************************************/
#pragma mark - Utilities

/*
 * This method opens Safari to redirect to Appaloosa store in order to download new version
 */
- (void)downloadNewVersion;

/**************************************************************************************************/
#pragma mark - App Feedback

/*
 * This method opens the feedback controller
 *
 * @param recipientsEmail - NSArray containing feedback email(s) adresses
 */
- (void)openFeedbackControllerWithRecipientsEmailArray:(NSArray *)recipientsEmail;

/*
 * This method displays a default button in order to open the feedback controller
 *
 * @param position - AppaloosaButtonPosition in the view (kAppaloosaButtonPositionRightBottom or kAppaloosaButtonPositionBottomRight)
 * @param recipientsEmail - NSArray containing feedback email(s) adresses
 */
- (void)feedbackControllerWithDefaultButtonAtPosition:(AppaloosaButtonPosition)position
                    forRecipientsEmailArray:(NSArray *)recipientsEmail;

/*
 * This method shows the default feedback button
 *
 * @param shouldShow - BOOL to show/hide the default button
 */
- (void)showDefaultFeedbackButton:(BOOL)shouldShow;

/**************************************************************************************************/
#pragma mark - Debug Panel Feedback

/*
 * This method opens the devpanel controller
 *
 */
- (void)openDevPanelController;

/*
 * This method displays a default button in order to open the devpanel controller
 *
 * @param position - AppaloosaButtonPosition in the view (kAppaloosaButtonPositionRightBottom or kAppaloosaButtonPositionBottomRight)
 */
- (void)devPanelWithDefaultButtonAtPosition:(AppaloosaButtonPosition)position;

/*
 * This method shows the default devpanl button
 *
 * @param shouldShow - BOOL to show/hide the default button
 */
- (void)showDefaultDevPanelButton:(BOOL)shouldShow;

/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (nonatomic) id<OTAppaloosaAgentDelegate> delegate;

/**
 This flag enables logging
 Default: NO
 */
@property (nonatomic, getter = isLogEnabled) BOOL logEnabled;


@end
