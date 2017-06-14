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
//  UIViewController+CurrentPresentedController.m
//
//  Created by Maxence Walbrou on 08/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "UIViewController+CurrentPresentedController.h"

@implementation UIViewController (CurrentPresentedController)



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
