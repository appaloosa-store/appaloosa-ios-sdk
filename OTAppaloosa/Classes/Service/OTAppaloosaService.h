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
//  OTAppaloosaService.h
//
//  Created by Cedric Pointel on 06/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTApplicationAuthorization;
@class OTAppaloosaApplication;

@interface OTAppaloosaService : NSObject

/**************************************************************************************************/
#pragma mark - Authorization

- (void)checkAuthorizationsWithStoreId:(NSString *)storeId
                                bundleId:(NSString *)bundleId
                           storeToken:(NSString *)storeToken
                          withSuccess:(void (^)(void))success
                              failure:(void (^)(OTApplicationAuthorization *appAuthorization))failure;

/**************************************************************************************************/
#pragma mark - Application Information

- (void)loadApplicationInformationWithStoreId:(NSString *)storeId
                                        bundleId:(NSString *)bundleId
                                   storeToken:(NSString *)storeToken
                                  withSuccess:(void (^)(OTAppaloosaApplication *application))success
                                      failure:(void (^)(NSString *message))failure;

/**************************************************************************************************/
#pragma mark - Application Update

- (void)checkApplicationUpdateWithStoreId:(NSString *)storeId
                                 bundleId:(NSString *)bundleId
                               storeToken:(NSString *)storeToken
                              withSuccess:(void (^)(BOOL shouldUpdate))success
                                  failure:(void (^)(NSString *message))failure;
@end
