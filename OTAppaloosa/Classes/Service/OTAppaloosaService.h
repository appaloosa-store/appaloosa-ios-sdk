//
//  OTAppaloosaService.h
//  Apploosa-SDK-HOME
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
@end
