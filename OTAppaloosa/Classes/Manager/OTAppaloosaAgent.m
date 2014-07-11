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
//  OTAppaloosaAgent.m
//
//  Created by Cedric Pointel on 06/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaAgent.h"

// Model
#import "OTAppaloosaApplication.h"
#import "OTApplicationUpdate.h"

// Utils
#import "OTAppaloosaUtils.h"

// Service
#import "OTAppaloosaService.h"
#import "OTAppaloosaUrlHelper.h"

const NSUInteger kAlertViewApplicationAuthorization = 1;
const NSUInteger kAlertViewDownloadUpdate           = 2;
const NSUInteger kAlertViewApplicationJailbreak     = 3;

@interface OTAppaloosaAgent ()

/**************************************************************************************************/
#pragma mark - Getters and Setters

// Appaloosa Store information
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *bundleId;
@property (strong, nonatomic) NSString *storeToken;

// Model
@property (strong, nonatomic) OTAppaloosaApplication *appaloosaApplication;
@property (strong, nonatomic) OTApplicationUpdate *appaloosaUpdate;

// Interface buttons
@property (strong, nonatomic) OTAppaloosaActionButtonsManager *actionButtonsManager;

// Services
@property (strong, nonatomic) OTAppaloosaService *appaloosaService;

@end

@implementation OTAppaloosaAgent

/**************************************************************************************************/
#pragma mark - Singleton

static OTAppaloosaAgent *manager;

+ (OTAppaloosaAgent *)sharedAgent
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (id)init
{
    if ((self = [super init]))
    {
        _appaloosaService = [[OTAppaloosaService alloc] init];
        
        // Default values
        _logEnabled = NO;
    }
    
    return self;
}

/**************************************************************************************************/
#pragma mark - Utilities

/*
 * This method registers your application in Appaloosa backend.
 * Call this method when the application starts.
 * @param storeId The store identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param tokenId The token identifier that you can find in http://www.appaloosa-store.com/settings.
 */
- (void)registerWithStoreId:(NSString*)storeId storeToken:(NSString*)storeToken
{
    [self registerWithStoreId:storeId
                   storeToken:storeToken
                  andDelegate:nil];
}

/*
 * This method registers your application in Appaloosa backend.
 * Call this method when the application starts.
 * @param storeId The store identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param tokenId The token identifier that you can find in http://www.appaloosa-store.com/settings.
 * @param delegate The delegate for Appaloosa agent
 */
- (void)registerWithStoreId:(NSString*)storeId storeToken:(NSString*)storeToken andDelegate:(id<OTAppaloosaAgentDelegate>)delegate;
{
    _storeId = storeId;
    _storeToken = storeToken;
    _bundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    _delegate = delegate;
    
    AppaloosaLog(@"Registering application with :\nstoreId : %@\nstoreToken : %@", _storeId, _storeToken);
}

- (BOOL)hasRegisteringInformation
{
    BOOL result = YES;
    
    if ((self.storeId == nil) &&
        (self.storeToken == nil))
    {
        result = NO;
        AppaloosaLog(@"You should provide a storeId and storeToken");
        AppaloosaLog(@"use - (void)registerWithStoreId:(NSString*)storeId storeToken:(NSString*)storeToken;");
        AppaloosaLog(@"or - (void)registerWithStoreId:(NSString*)storeId storeToken:(NSString*)storeToken andDelegate:(id<OTAppaloosaAgentDelegate>)delegate;");
    }
    
    return result;
}

- (void)setServerBaseURL:(NSString *)serverBaseURL
{
    [OTAppaloosaUrlHelper setServerBaseURL:serverBaseURL];
}

/**************************************************************************************************/
#pragma mark - Application Authorizations

/*
 * This method checks with Appaloosa backend if the user is authorized to execute the application. 
 *   If no internet connection is availabe, the latest status is read from the keychain.
 */
- (void)checkAuthorizations
{
    if ([self hasRegisteringInformation] == NO) return;
    
    [self.appaloosaService checkAuthorizationsWithStoreId:self.storeId
                                                 bundleId:self.bundleId
                                               storeToken:self.storeToken
                                              withSuccess:^{
                                                  
                                                  [self authorizationAllowed];
                                              }
                                                  failure:^(OTApplicationAuthorization *appAuthorization) {
                                                      
                                                      [self authorizationNotAllowedWith:appAuthorization];
                                                  }];
}

/*
 * This method is called when the user is authorized to execute the application
 */
- (void)authorizationAllowed
{
    if ([self.delegate respondsToSelector:@selector(applicationAuthorizationsAllowed)])
    {
        [self.delegate applicationAuthorizationsAllowed];
    }
}

/*
 * This method is called when the user isn't authorized to execute the application
 * @param appAuthorization The response received by the back end (status + message)
 */
- (void)authorizationNotAllowedWith:(OTApplicationAuthorization *)appAuthorization
{
    if ([self.delegate respondsToSelector:@selector(applicationAuthorizationsNotAllowedWithStatus:andMessage:)])
    {
        [self.delegate applicationAuthorizationsNotAllowedWithStatus:appAuthorization.status
                                                          andMessage:appAuthorization.message];
    }
    else
    {
        UIAlertView *alertView = [OTAppaloosaUtils displayAlertWithMessage:appAuthorization.message
                                                              withDelegate:self];
        alertView.tag = kAlertViewApplicationAuthorization;
    }
}

- (void)blockJailbrokenDevice
{
    if([OTAppaloosaUtils checkDeviceJailbreak].status == OTAppaloosaAutorizationsStatusJailbroken) {
        AppaloosaLog(@"Device is jailbroken, exiting");
        UIAlertView *alertView = [OTAppaloosaUtils displayAlertWithMessage:[OTAppaloosaUtils checkDeviceJailbreak].message
                                                              withDelegate:self];
        alertView.tag = kAlertViewApplicationJailbreak;
        [alertView show];
    }
}

/**************************************************************************************************/
#pragma mark - Application Information

- (void)loadApplicationInformationWithSuccess:(void (^)(OTAppaloosaApplication *application))success
                                      failure:(void (^)(NSString *message))failure
{
    [self.appaloosaService loadApplicationInformationWithStoreId:self.storeId
                                                        bundleId:self.bundleId
                                                      storeToken:self.storeToken
                                                     withSuccess:^(OTAppaloosaApplication *application) {
                                                         
                                                         self.appaloosaApplication = application;
                                                         if (success)
                                                         {
                                                             success(application);
                                                         }
                                                         
                                                     } failure:^(NSString *message) {
                                                         
                                                         if (failure)
                                                         {
                                                             failure(message);
                                                         }
                                                     }];
}

/**************************************************************************************************/
#pragma mark - Application Updates

- (void)checkUpdates
{
    if ([self hasRegisteringInformation] == NO) return;
    
    [self.appaloosaService checkApplicationUpdateWithStoreId:self.storeId
                                                    bundleId:self.bundleId
                                                  storeToken:self.storeToken
                                                 withSuccess:^(OTApplicationUpdate *appUpdate) {
                                                     
                                                     self.appaloosaUpdate = appUpdate;
                                                     [self checkUpdateRequestSuccessWithApplicationUpdate:appUpdate];
                                                     
                                                 } failure:^(NSError *error) {
                                                     
                                                     [self checkUpdateRequestFailureWithError:error];
                                                 }];
}

- (void)checkUpdateRequestSuccessWithApplicationUpdate:(OTApplicationUpdate *)appUpdate
{
    AppaloosaLog(@"Checking Update");
    
    if ([self.delegate respondsToSelector:@selector(applicationUpdateRequestSuccessWithApplicationUpdateStatus:)])
    {
        [self.delegate applicationUpdateRequestSuccessWithApplicationUpdateStatus:appUpdate.status];
    }
    else
    {
        if (appUpdate.status == OTAppaloosaUpdateStatusNoUpdateNeeded)
        {
            AppaloosaLog(@"application is up to date, no need to update");
        }
        else if (appUpdate.status == OTAppaloosaUpdateStatusUpdateNeeded)
        {
            AppaloosaLog(@"application is not up to date, need to update");
            
            UIAlertView *alert = [OTAppaloosaUtils displayAlertWithMessage:@"An update is available. Would you like to update ?"
                                                               actionTitle:@"Ok"
                                                              withDelegate:self];
            alert.tag = kAlertViewDownloadUpdate;
        }
        else
        {
            AppaloosaLog(@"Checking Update impossible. Finished with status : %@", [appUpdate stringAccordingUpdateStatus]);
        }
    }
}

- (void)checkUpdateRequestFailureWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(applicationUpdateRequestFailureWithError:)])
    {
        [self.delegate applicationUpdateRequestFailureWithError:error];
    }
}

/**************************************************************************************************/
#pragma mark - Application Download

- (void)downloadNewVersion
{
    [self openSafariToDownloadApplication];
}

- (void)openSafariToDownloadApplication
{
    NSString *installUrl = [self.appaloosaUpdate downloadUrl];

    if (installUrl)
    {
        installUrl = [OTAppaloosaUrlHelper addParamsToDownloadUrl:installUrl];
        
        AppaloosaLog(@"Open Safari to download IPA at url : %@",installUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
    }
    else
    {
        AppaloosaLog(@"No url to download the application. Call 'checkUpdates' before downloading a new version.");
    }
}

/**************************************************************************************************/
#pragma mark - App Feedback

- (void)openFeedbackControllerWithRecipientsEmailArray:(NSArray *)recipientsEmail
{
    if (self.actionButtonsManager == nil)
    {
        self.actionButtonsManager = [[OTAppaloosaActionButtonsManager alloc] init];
    }

    [self.actionButtonsManager presentFeedbackWithRecipientsEmailArray:recipientsEmail];
}

- (void)feedbackControllerWithDefaultButtonAtPosition:(AppaloosaButtonPosition)position
                    forRecipientsEmailArray:(NSArray *)emailsArray
{
    if (self.actionButtonsManager == nil)
    {
        self.actionButtonsManager = [[OTAppaloosaActionButtonsManager alloc] init];
    }
    
    [self.actionButtonsManager initializeDefaultFeedbackButtonWithPosition:position
                                                   forRecipientsEmailArray:emailsArray];
}

- (void)showDefaultFeedbackButton:(BOOL)shouldShow
{
    if (self.actionButtonsManager == nil)
    {
        self.actionButtonsManager = [[OTAppaloosaActionButtonsManager alloc] init];
    }
    
    [self.actionButtonsManager showDefaultFeedbackButton:shouldShow];
}

/**************************************************************************************************/
#pragma mark - Debug Panel Feedback

- (void)openDevPanelController
{
    if (self.actionButtonsManager == nil)
    {
        self.actionButtonsManager = [[OTAppaloosaActionButtonsManager alloc] init];
    }
    
    [self.actionButtonsManager presentDevPanel];
}

- (void)devPanelWithDefaultButtonAtPosition:(AppaloosaButtonPosition)position
{
    if (self.actionButtonsManager == nil)
    {
        self.actionButtonsManager = [[OTAppaloosaActionButtonsManager alloc] init];
    }

    [self.actionButtonsManager initializeDefaultDevPanelButtonWithPosition:position];
}

- (void)showDefaultDevPanelButton:(BOOL)shouldShow
{
    if (self.actionButtonsManager == nil)
    {
        self.actionButtonsManager = [[OTAppaloosaActionButtonsManager alloc] init];
    }
    
    [self.actionButtonsManager showDefaultDevPanelButton:shouldShow];
}

/**************************************************************************************************/
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case kAlertViewApplicationAuthorization:
        case kAlertViewApplicationJailbreak:
        {
            exit(0);
            break;
        }
        case kAlertViewDownloadUpdate:
        {
            if (buttonIndex != alertView.cancelButtonIndex)
            {
                [self openSafariToDownloadApplication];
            }
        }
        default:
            break;
    }
}

@end
