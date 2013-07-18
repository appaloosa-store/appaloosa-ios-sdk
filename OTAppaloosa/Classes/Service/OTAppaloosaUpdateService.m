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
//  OTAppaloosaUpdateService.m
//
//  Created by Abdou Benhamouche on 10/12/12.
//  Copyright (c) 2012 OCTO Technology. All rights reserved.
//

#import "OTAppaloosaUpdateService.h"

#define APPALOOSA_BEGIN_URL @"https://www.appaloosa-store.com/"
#define APPALOOSA_MIDDLE_URL @"/mobile_applications/"
#define APPALOOSA_JSON_END_URL @".json?token="
#define APPALOOSA_INSTALL_END_URL @"/install?token="

#define JSON_ID_KEY @"id"
#define JSON_VERSION_KEY @"version"

@interface OTAppaloosaUpdateService ()

- (void)shouldUpdateApp;
- (void)checkFromUpdateResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error;
- (BOOL)mustBeUpdatedWithVersion:(NSString *)newVersion;
- (NSString *)installUrlWithStoreID:(NSString *)theStoreID appID:(NSString *)theBundleID storeToken:(NSString *)theStoreToken;

@end

@implementation OTAppaloosaUpdateService

/**************************************************************************************************/
#pragma mark - Getters & Setters

@synthesize delegate;
@synthesize storeID;
@synthesize bundleID;
@synthesize storeToken;
@synthesize appID;

/**************************************************************************************************/
#pragma mark - Birth & Death

- (id)initWithDelegate:(id<OTAppaloosaUpdateServiceDelegate>)theDelegate;
{
    self = [super init];
    if (self && theDelegate) 
    {
        self.delegate = theDelegate;
    }
    return self;
}

/**************************************************************************************************/
#pragma mark - Manage updates

- (void)checkForUpdateWithStoreID:(NSString *)theStoreID appID:(NSString *)theBundleID storeToken:(NSString *)theStoreToken
{
    self.storeID = theStoreID;
    self.bundleID = theBundleID;
    self.storeToken = theStoreToken;
    
    NSString *urlString = [NSString stringWithFormat
                           :@"%@%@%@%@%@%@",
                           APPALOOSA_BEGIN_URL,
                           self.storeID,
                           APPALOOSA_MIDDLE_URL,
                           self.bundleID,
                           APPALOOSA_JSON_END_URL,
                           self.storeToken];
    
    NSURL *url = [NSURL URLWithString:urlString]; 
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] 
                                       queue:[NSOperationQueue mainQueue] 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) 
    {
        [self checkFromUpdateResponse:response data:data error:error];
    }];
}

/**************************************************************************************************/
#pragma mark - Private

- (void)checkFromUpdateResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error
{
    if (!error)
    {
        NSDictionary *dataDictionnary = [NSJSONSerialization JSONObjectWithData: data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
                
        self.appID = [dataDictionnary objectForKey:JSON_ID_KEY];
        
        if ([self mustBeUpdatedWithVersion:[dataDictionnary objectForKey:JSON_VERSION_KEY]])
            if ([self.delegate respondsToSelector:@selector(updateIsAvailableOnAppaloosaStore)])
        {
            [self performSelectorOnMainThread:@selector(shouldUpdateApp) withObject:nil waitUntilDone:NO];
        }
    }
}


- (void)shouldUpdateApp
{
    [self.delegate updateIsAvailableOnAppaloosaStore];
}

- (BOOL)mustBeUpdatedWithVersion:(NSString *)newVersion
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    return ![newVersion isEqualToString:currentVersion];
}


/**************************************************************************************/
#pragma mark - Install URL 

- (NSString *)installUrlWithStoreID:(NSString *)theStoreID appID:(NSString *)theBundleID storeToken:(NSString *)theStoreToken
{
    NSString *installUrl = [NSString stringWithFormat
                            :@"%@%@%@%@%@%@",
                            APPALOOSA_BEGIN_URL,
                            self.storeID,
                            APPALOOSA_MIDDLE_URL,
                            self.appID,
                            APPALOOSA_INSTALL_END_URL,
                            self.storeToken];
    
    return installUrl;
}


/**************************************************************************************************/
#pragma mark - Appaloosa service delegate

- (void)downloadNewVersionOfTheApp
{
    if (storeID && bundleID && storeToken)
    {
        NSString *installUrl = [self installUrlWithStoreID:storeID appID:bundleID storeToken:storeToken];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
    }
}

@end
