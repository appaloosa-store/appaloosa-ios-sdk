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
//  OTAppaloosaService.m
//
//  Created by Cedric Pointel on 06/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaService.h"

// Fmk
#import <Reachability/Reachability.h>

// Model
#import "OTAppaloosaApplication.h"
#import "OTApplicationAuthorization.h"
#import "OTApplicationUpdate.h"

// Services
#import "OTAppaloosaUrlHelper.h"

// Utils
#import "OTAppaloosaUtils.h"

@interface OTAppaloosaService ()

@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation OTAppaloosaService

/**************************************************************************************************/
#pragma mark - Birth and Death

- (id)init
{
    if ((self = [super init]))
    {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
    }
    
    return self;
}

/**************************************************************************************************/
#pragma mark - Authorization

- (void)checkAuthorizationsWithStoreId:(NSString *)storeId
                              bundleId:(NSString *)bundleId
                            storeToken:(NSString *)storeToken
                           withSuccess:(void (^)(void))success
                               failure:(void (^)(OTApplicationAuthorization *appAuthorization))failure;
{
    if ([[Reachability reachabilityForInternetConnection] isReachable])
    {
        NSString *urlString = [OTAppaloosaUrlHelper urlForApplicationAuthorizationWithStoreId:storeId
                                                                                        bundleId:bundleId
                                                                                   storeToken:storeToken];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AppaloosaLog(@"Retrieve application authorization from %@",urlString);
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:self.queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                               
                                               OTApplicationAuthorization *appAuthorization = [[OTApplicationAuthorization alloc] init];
                                   
                                               if (error)
                                               {
                                                   appAuthorization.status = OTAppaloosaAutorizationsStatusRequestError;
                                               }
                                               else
                                               {
                                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                        options:kNilOptions
                                                                                                          error:&error];
                                                   if ((error == nil) && json)
                                                   {
                                                       appAuthorization = [[OTApplicationAuthorization alloc] initWithJsonDictionary:json];
                                                   }
                                               }
                                               
                                               
                                               if (appAuthorization.status == OTAppaloosaAutorizationsStatusAuthorized) {
                                                
                                                   AppaloosaLog(@"This application is authorized");
                                                   [OTAppaloosaUtils setIsLocallyBlacklisted:NO];
                                                   [OTAppaloosaUtils storeAnalyticsEndpoint:appAuthorization.analyticsEndpoint];
                                                   if (success)
                                                   {
                                                       dispatch_sync(dispatch_get_main_queue(), ^{
                                                          
                                                           success();
                                                       });
                                                   }
                                               }
                                               else
                                               {
                                                   AppaloosaLog(@"This application is not authorized with status %@",[appAuthorization stringAccordingAuthorizationStatus]);
                                                   if(appAuthorization.status == OTAppaloosaAutorizationsStatusNotAuthorized)
                                                       [OTAppaloosaUtils setIsLocallyBlacklisted:YES];

                                                   if (failure)
                                                   {
                                                       dispatch_sync(dispatch_get_main_queue(), ^{
                                                       
                                                           failure(appAuthorization);
                                                       });
                                                   }
                                               }
                                           }];
    }
    else
    {
        AppaloosaLog(@"Unable to check authorization because connection seems unavaible, reading from latest local blacklist status");

        if(![OTAppaloosaUtils isLocallyBlacklisted]) {
            [OTAppaloosaUtils refreshAnalyticsEndpoint];
            AppaloosaLog(@"This application is authorized");
            success();
            return;
        }

        [OTAppaloosaUtils setIsLocallyBlacklisted:YES];
        OTApplicationAuthorization *appAuthorization = [[OTApplicationAuthorization alloc] init];
        appAuthorization.status =  OTAppaloosaAutorizationsStatusNotAuthorized;
        appAuthorization.message = @"Your account has been blacklisted";
        AppaloosaLog(@"This application is not authorized with status %@",[appAuthorization stringAccordingAuthorizationStatus]);
        if(failure)
            failure(appAuthorization);
    }
}

/**************************************************************************************************/
#pragma mark - Application Information

- (void)loadApplicationInformationWithStoreId:(NSString *)storeId
                                        bundleId:(NSString *)bundleId
                                   storeToken:(NSString *)storeToken
                                  withSuccess:(void (^)(OTAppaloosaApplication *application))success
                                      failure:(void (^)(NSString *message))failure
{
    if ([[Reachability reachabilityForInternetConnection] isReachable])
    {
        NSString *urlString = [OTAppaloosaUrlHelper urlForApplicationInformationWithStoreId:storeId
                                                                                        bundleId:bundleId
                                                                                   storeToken:storeToken];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AppaloosaLog(@"Retrieve application informations from %@",urlString);
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:self.queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   if (!error)
                                   {
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:kNilOptions
                                                                                              error:&error];
                                       if ((error == nil) && json)
                                       {
                                           OTAppaloosaApplication *application = [[OTAppaloosaApplication alloc] initWithJsonDictionary:json];
                                           
                                           if(application && success)
                                           {
                                               dispatch_sync(dispatch_get_main_queue(), ^{
                                                   
                                                   success(application);
                                               });
                                               return;
                                           }
                                       }
                                   }
                                   
                                   if(failure)
                                   {
                                       dispatch_sync(dispatch_get_main_queue(), ^{
                                           
                                           AppaloosaLog(@"Unable to get Appaloosa application version");
                                           failure(@"An error has occurred");
                                       });
                                   }
         
                               }];
    }
}

/**************************************************************************************************/
#pragma mark - Application Update

- (void)checkApplicationUpdateWithStoreId:(NSString *)storeId
                                 bundleId:(NSString *)bundleId
                               storeToken:(NSString *)storeToken
                              withSuccess:(void (^)(OTApplicationUpdate *appUpdate))success
                                  failure:(void (^)(NSError *error))failure;
{
    NSString *urlString = [OTAppaloosaUrlHelper urlForApplicationUpdateWithStoreId:storeId
                                                                          bundleId:bundleId
                                                                        storeToken:storeToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AppaloosaLog(@"Check Application Update from %@",urlString);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               OTApplicationUpdate *appUpdate = nil;
                               
                               if (error == nil)
                               {
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:kNilOptions
                                                                                          error:&error];
                                   if (json)
                                   {
                                       appUpdate = [[OTApplicationUpdate alloc] initWithJsonDictionary:json];
                                   }
                               }
                               
                               if(success && appUpdate)
                               {
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       
                                       success(appUpdate);
                                   });
                                   return;
                               }
                               else
                               {
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       
                                       AppaloosaLog(@"Unable to check Application Updates with error : %@", error);
                                       failure(error);
                                   });
                               }
                           }];
}
@end
