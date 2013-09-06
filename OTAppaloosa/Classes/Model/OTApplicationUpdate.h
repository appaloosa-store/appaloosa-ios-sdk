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
