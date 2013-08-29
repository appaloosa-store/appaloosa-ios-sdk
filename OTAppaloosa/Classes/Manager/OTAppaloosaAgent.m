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

// Utils
#import "OTAppaloosaUtils.h"

// Service
#import "OTAppaloosaService.h"
#import "OTAppaloosaUrlHelper.h"

const NSUInteger kAlertViewApplicationAuthorization = 1;
const NSUInteger kAlertViewDownloadUpdate = 2;

@interface OTAppaloosaAgent ()

/**************************************************************************************************/
#pragma mark - Getters and Setters

// Appaloosa Store information
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *bundleId;
@property (strong, nonatomic) NSString *storeToken;

// Appaloosa Application
@property (strong, nonatomic) OTAppaloosaApplication *appaloosaApplication;

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

/**************************************************************************************************/
#pragma mark - Authorizations

/*
 * This method checks with Appaloosa backend if the user is authorized to execute the application.
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

- (void)checkUpdates
{
    if ([self hasRegisteringInformation] == NO) return;
    
    if (self.appaloosaApplication)
    {
        [self checkUpdatsWithAppaloosaApplication:self.appaloosaApplication];
    }
    else
    {
        [self loadApplicationInformationWithSuccess:^(OTAppaloosaApplication *application)
         {
             [self checkUpdatsWithAppaloosaApplication:application];
         }
                                            failure:^(NSString *message)
         {
             
         }];
    }
}

- (void)checkUpdatsWithAppaloosaApplication:(OTAppaloosaApplication *)application
{
    NSString *appaloosaApplicationVersion = application.version;
    NSString *currentApplicationVersion = [OTAppaloosaUtils currentApplicationVersion];
    
    AppaloosaLog(@"Check Update");
    AppaloosaLog(@"application version on Appaloosa: %@", appaloosaApplicationVersion);
    AppaloosaLog(@"installed application version: %@", currentApplicationVersion);
    
    if ([appaloosaApplicationVersion isEqualToString:currentApplicationVersion])
    {
        AppaloosaLog(@"application is up to date, no need to update");
        [self applicationIsUpToDate];
    }
    else
    {
        AppaloosaLog(@"application is not up to date, need to update");
        [self applicationIsNotUpToDateWithInstalledVersion:currentApplicationVersion
                                       andAppaloosaVersion:appaloosaApplicationVersion];
    }

}

- (void)applicationIsUpToDate
{
    if ([self.delegate respondsToSelector:@selector(applicationIsUpToDate)])
    {
        [self.delegate applicationIsUpToDate];
    }
}

- (void)applicationIsNotUpToDateWithInstalledVersion:(NSString *)installedVersion andAppaloosaVersion:(NSString *)appaloosaVersion;
{
    if ([self.delegate respondsToSelector:@selector(applicationIsNotUpToDateWithInstalledVersion:andAppaloosaVersion:)])
    {
        [self.delegate applicationIsNotUpToDateWithInstalledVersion:installedVersion
                                                andAppaloosaVersion:appaloosaVersion];
    }
    else
    {
        UIAlertView *alert = [OTAppaloosaUtils displayAlertWithMessage:@"An update is available. Would you like to update ?"
                                                           actionTitle:@"Ok"
                                                          withDelegate:self];
        alert.tag = kAlertViewDownloadUpdate;
    }
}

/**************************************************************************************************/
#pragma mark - Application Download

- (void)downloadNewVersion
{
    if (self.appaloosaApplication)
    {
        [self openSafariToDownloadApplication];
    }
    else
    {
        [self loadApplicationInformationWithSuccess:^(OTAppaloosaApplication *application)
         {
             [self openSafariToDownloadApplication];
         }
                                            failure:^(NSString *message)
         {
             
         }];
    }
}

- (void)openSafariToDownloadApplication
{
    NSString *installUrl = [OTAppaloosaUrlHelper urlForDownloadApplicationWithId:self.appaloosaApplication.identifier
                                                                         storeId:self.storeId
                                                                        bundleId:self.bundleId
                                                                      storeToken:self.storeToken];

    AppaloosaLog(@"Open Safari to download IPA at url : %@",installUrl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
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

/**************************************************************************************************/
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case kAlertViewApplicationAuthorization:
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
