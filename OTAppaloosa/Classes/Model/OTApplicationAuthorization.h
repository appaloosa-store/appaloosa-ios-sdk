//
//  OTApplicationAuthorization.h
//  Apploosa-SDK-HOME
//
//  Created by Cedric Pointel on 07/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OTAppaloosaAutorizationsStatusUnknown,
    OTAppaloosaAutorizationsStatusUnknownDevice,
    OTAppaloosaAutorizationsStatusUnregisteredDevice,
    OTAppaloosaAutorizationsStatusAuthorized,
    OTAppaloosaAutorizationsStatusNotAuthorized,
    OTAppaloosaAutorizationsStatusNoNetwork,
    OTAppaloosaAutorizationsStatusRequestError,
} OTAppaloosaAutorizationsStatus;

@interface OTApplicationAuthorization : NSObject

/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (assign, nonatomic) OTAppaloosaAutorizationsStatus status;
@property (strong, nonatomic) NSString                       *message;

/**************************************************************************************************/
#pragma mark - Birth and Death

- (id)initWithJsonDictionary:(NSDictionary *)jsonDict;

/**************************************************************************************************/
#pragma mark - Utilities

- (NSString *)stringAccordingAuthorizationStatus;

@end
