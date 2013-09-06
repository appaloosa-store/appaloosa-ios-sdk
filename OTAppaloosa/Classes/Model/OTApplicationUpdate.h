//
//  OTApplicationUpdate.h
//  AppaloosaTestFmk
//
//  Created by Cedric Pointel on 04/09/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OTAppaloosaUpdateStatusUnregisteredDevice,
    OTAppaloosaUpdateStatusUnknownApplication,
    OTAppaloosaUpdateStatusNoUpdateNeeded,
    OTAppaloosaUpdateStatusUpdateNeeded,
    OTAppaloosaUpdateStatusDeviceIdFormatError,
} OTAppaloosaUpdateStatus;

@interface OTApplicationUpdate : NSObject

/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (assign, nonatomic) OTAppaloosaUpdateStatus status;
@property (strong, nonatomic) NSString                *downloadUrl;
@property (strong, nonatomic) NSString                *identifierApplicationVersion;

/**************************************************************************************************/
#pragma mark - Birth and Death

- (id)initWithJsonDictionary:(NSDictionary *)jsonDict;

/**************************************************************************************************/
#pragma mark - Utilities

- (NSString *)stringAccordingUpdateStatus;

@end
