//
//  OTAppaloosaManager.h
//  Apploosa-SDK-HOME
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
 * @param storeId The store identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param tokenId The token identifier that you can find in http://www.appaloosa-store.com/settings.
 */
- (void)registerWithStoreId:(NSString*)storeId storeToken:(NSString*)storeToken;

/*
 * This method registers your application in Appaloosa backend.
 * Call this method when the application starts.
 * @param storeId The store identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param tokenId The token identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param delegate The delegate for Appaloosa agent
 */
- (void)registerWithStoreId:(NSString*)storeId storeToken:(NSString*)storeToken andDelegate:(id<OTAppaloosaAgentDelegate>)delegate;


/**************************************************************************************************/
#pragma mark - Check

/*
 * This method checks if the application is authorized to be executed
 *
 * Default behaviour :
 * - a success does nothing
 * - a failure displays an alertview to inform the user then the application is closed
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
 * This method opens Safari to redirect to Appaloosa store in order to download new version
 */
- (void)openFeedbackControllerWithRecipientsEmailArray:(NSArray *)recipientsEmail;

- (void)feedbackControllerWithDefaultButtonAtPosition:(AppaloosaButtonPosition)position
                    forRecipientsEmailArray:(NSArray *)emailsArray;

/**************************************************************************************************/
#pragma mark - Debug Panel Feedback

- (void)openDevPanelController;
- (void)devPanelWithDefaultButtonAtPosition:(AppaloosaButtonPosition)position;

/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (nonatomic) id<OTAppaloosaAgentDelegate> delegate;

/**
 This flag enables logging
 Default: NO
 */
@property (nonatomic, getter = isLogEnabled) BOOL logEnabled;


@end
