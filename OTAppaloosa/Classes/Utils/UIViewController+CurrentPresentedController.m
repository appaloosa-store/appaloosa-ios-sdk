//
//  UIViewController+CurrentPresentedController.m
//  OTInAppFeedback
//
//  Created by Maxence Walbrou on 08/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "UIViewController+CurrentPresentedController.h"

@implementation UIViewController (CurrentPresentedController)



/**
 * @return Application current displayed ViewController
 */
+ (UIViewController *)currentPresentedController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


@end
