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
//  OTAppaloosaUpdateService.h
//
//  Created by Abdou Benhamouche on 10/12/12.
//  Copyright (c) 2012 OCTO Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************************************************************************************/
#pragma mark - Service Delegate

@protocol OTAppaloosaUpdateServiceDelegate<NSObject>

- (void)updateIsAvailableOnAppaloosaStore;

@end


/**************************************************************************************************/
#pragma mark - Interface

/**
 * AutoUpdate Service.
 */
@interface OTAppaloosaUpdateService : NSObject


/**************************************************************************************************/
#pragma mark - Birth & Death

- (id)initWithDelegate:(id<OTAppaloosaUpdateServiceDelegate>)theDelegate;

/**************************************************************************************************/
#pragma mark - Getters & Setters

/** @name Properties */

/** Delegate called for user interaction */
@property (nonatomic, assign) id<OTAppaloosaUpdateServiceDelegate>  delegate;

/** ID of your Store on Appaloosa Store */
@property (nonatomic, strong) NSString                              *storeID;
/** Bundle ID of your App on Appaloosa Store */
@property (nonatomic, strong) NSString                              *bundleID;
/** Token */
@property (nonatomic, strong) NSString                              *storeToken;
/** ID of your App on Appaloosa Store */
@property (nonatomic, strong) NSString                              *appID;


/**************************************************************************************************/
#pragma mark - Manage updates

/** @name Update methods */

/**
 * Call Appaloosa Store Server to check if a new version of the App is available.
 *
 * @param storeID ID of your Store on Appaloosa Server.
 * @param bundleID Bundle ID of your App on Appaloosa Store.
 * @param storeToken Token.
 */
- (void)checkForUpdateWithStoreID:(NSString *)storeID
                            appID:(NSString *)bundleID
                       storeToken:(NSString *)storeToken;

/**
 * Ask for download the last version of the App.
 */
- (void)downloadNewVersionOfTheApp;

@end
