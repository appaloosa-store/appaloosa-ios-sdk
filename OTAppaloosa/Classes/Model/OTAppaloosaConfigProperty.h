//
//  OTAppaloosaConfigProperty.h
//  OTInAppFeedback
//
//  Created by Reda on 18/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAppaloosaConfigProperty : NSObject

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *value;

- (id)initWithLabel:(NSString *)label andValue:(NSString *)value;

@end
