//
//  OTAppaloosaApplication.h
//  Apploosa-SDK-HOME
//
//  Created by Cedric Pointel on 07/08/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAppaloosaApplication : NSObject

/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *version;

/**************************************************************************************************/
#pragma mark - Birth and Death

- (id)initWithJsonDictionary:(NSDictionary *)jsonDict;

@end
