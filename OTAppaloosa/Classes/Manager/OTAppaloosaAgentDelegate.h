//
//  OTAppaloosaAgentDelegate.h
//  Apploosa-SDK-HOME
//
//  Created by Cedric Pointel on 07/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OTApplicationAuthorization.h"

@protocol OTAppaloosaAgentDelegate <NSObject>

@optional

/**************************************************************************************************/
#pragma mark - Application Authorizations Methods Delegate

/**
 * Implement to be inform that the user is authorized to execute the application
 *
 * By default the SDK does nothing.
 *
 */
- (void)applicationAuthorizationsAllowed;

/**
 * Implement to be inform that the user isn't authorized to execute the application
 *
 * By default the SDK shows an alert view with the appropriated message and kills the application.
 * Implement this method if you want your own behaviour.
 *
 */
- (void)applicationAuthorizationsNotAllowedWithStatus:(OTAppaloosaAutorizationsStatus)status
                                           andMessage:(NSString *)message;

/**************************************************************************************************/
#pragma mark - Application Updates Methods Delegate

/**
 */
- (void)applicationIsUpToDate;

/**
 */
- (void)applicationIsNotUpToDateWithInstalledVersion:(NSString *)installedVersion
                                 andAppaloosaVersion:(NSString *)appaloosaVersion;

@end
