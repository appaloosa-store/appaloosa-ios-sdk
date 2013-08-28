//
//  OTAppaloosaApplication.m
//  Apploosa-SDK-HOME
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
