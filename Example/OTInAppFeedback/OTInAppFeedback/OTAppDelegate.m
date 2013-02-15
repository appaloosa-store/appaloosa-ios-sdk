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
//
//  OTAppDelegate.m
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppDelegate.h"

// ViewController :
#import "OTViewController.h"

// Framework :
#import "OTAppaloosa.h"


@implementation OTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *viewController = [[OTViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
       
    // Initialize in app feedback custom button (necessary only if you use default feedback in the app) :
    [[OTAppaloosaInAppFeedbackManager sharedManager] initializeDefaultFeedbackButtonWithPosition:kFeedbackButtonPositionRightBottom forRecipientsEmailArray:@[@"mwalbrou@octo.com"]];
    
    return YES;
}

@end
