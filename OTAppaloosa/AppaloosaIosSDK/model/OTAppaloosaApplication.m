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
//  OTAppaloosaApplication.m
//
//  Created by Cedric Pointel on 07/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaApplication.h"

// Utils
#import "OTAppaloosaUtils.h"

const NSString *kApplicationIdKey = @"id";
const NSString *kApplicationVersionKey = @"version";

@implementation OTAppaloosaApplication

/**************************************************************************************************/
#pragma mark - Birth and Death

- (id)initWithJsonDictionary:(NSDictionary *)jsonDict
{
    if (![jsonDict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    if ((self = [super init]))
    {
        id value;
        
        value = [jsonDict objectForKey:(NSString *)kApplicationIdKey];
        if ([value isKindOfClass:[NSNumber class]])
        {
            _identifier = [value stringValue];
        }
        
        value = [jsonDict objectForKey:(NSString *)kApplicationVersionKey];
        if ([value isKindOfClass:[NSString class]])
        {
            _version = value;
        }
    }
    
    return self;
}

@end
