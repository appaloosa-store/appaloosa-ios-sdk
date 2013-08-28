//
//  OTAppaloosaUrlHelper.h
//  Apploosa-SDK-HOME
//
//  Created by Cedric Pointel on 06/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAppaloosaUrlHelper : NSObject

/**************************************************************************************************/
#pragma mark - Authorization

+ (NSString *)urlForApplicationAuthorizationWithStoreId:(NSString *)storeId bundleId:(NSString *)bundleId storeToken:(NSString *)storeToken;

/**************************************************************************************************/
#pragma mark - Application Information 

+ (NSString *)urlForApplicationInformationWithStoreId:(NSString *)storeId bundleId:(NSString *)bundleId storeToken:(NSString *)storeToken;
+ (NSString *)urlForDownloadApplicationWithId:(NSString *)appId storeId:(NSString *)storeId bundleId:(NSString *)bundleId storeToken:(NSString *)storeToken;

@end
