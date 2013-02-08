//
//  NSObject+performBlockAfterDelay.m
//  frIphoneHBK
//
//  Created by Maxence Walbrou on 21/02/12.
//  Copyright (c) 2012 OCTO TECHNOLOGY. All rights reserved.
//

#import "NSObject+performBlockAfterDelay.h"

@implementation NSObject (performBlockAfterDelay)

/**
 * @brief Perform a block after delay
 * @param delay in seconds
 */
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}
@end
