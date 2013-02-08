//
//  NSObject+performBlockAfterDelay.h
//  frIphoneHBK
//
//  Created by Maxence Walbrou on 21/02/12.
//  Copyright (c) 2012 OCTO TECHNOLOGY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (performBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
