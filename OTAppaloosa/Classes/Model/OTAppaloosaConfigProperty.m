//
//  OTAppaloosaConfigProperty.m
//  OTInAppFeedback
//
//  Created by Reda on 18/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaConfigProperty.h"

@implementation OTAppaloosaConfigProperty

- (id)initWithLabel:(NSString *)label andValue:(NSString *)value
{
    self = [super init];
    
    if (label != nil && [label isKindOfClass:[NSString class]])
    {
        self.label = label;
    }
    if (value != nil && [value isKindOfClass:[NSString class]])
    {
        self.value = value;
    }
    return self;
}

@end
