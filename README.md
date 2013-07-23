Appaloosa SDK
=============

Overview
--------

Appaloosa SDK library is a simple library that helps you to:
 
* Auto-update your application stored on [Appaloosa Store](http://www.appaloosa-store.com/) server
* Receive feedback from your users directly from the app (iPhone and iPad)
* Launch a dev-panel giving information about the device and the application

Requirements
------------

Appaloosa SDK library use ARC and is compatible with iOS 5+.


Integrate Appaloosa SDK with CocoaPods
----------------------------------------

Simply add the following line to your Podfile :
       
`pod 'OTAppaloosa', :podspec => "https://raw.github.com/octo-online/appaloosa-ios-sdk/0.3.2/OTAppaloosa.podspec"`

Refer to [CocoaPods](https://github.com/CocoaPods/CocoaPods) for more information about it.

Integrate Appaloosa SDK the old fashioned way
-----------------------------------------------

- Download and import OTAppaloosa sources and its dependency : [TPKeyboardAvoiding](https://github.com/michaeltyson/TPKeyboardAvoiding).
- Add OTAppaloosa sources to your project.

Check for application update - simple version
-----------------------------------------------

In your AppDelegate.m file, launch the autoupdate when your application starts : 
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. In method `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`, add the following code line:

	[[OTAppaloosaSimpleUpdateService sharedInstance]checkForUpdateWithStoreID:STORE_ID storeToken:STORE_TOKEN];

Check for application update - clever version
-----------------------------------------------


1. Into your AppDelegate.h file
    1. Add the OTAppaloosaUpdateServiceDelegate into your interface:

            @interface AppDelegate : UIResponder <UIApplicationDelegate, AppaloosaServiceDelegate>

    2. Add an OTAppaloosaUpdateService property:

            @property (nonatomic, strong) AppaloosaService *appaloosaService;

2. Into your AppDelegate.m file (launch of the autoupdate during application start)
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. Add the OTAppaloosaUpdateService synthesize:

            @synthesize appaloosaService;

	3. Into method `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`, add the following code lines:

        	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        	NSString *bundleIDFormatted = [bundleID urlEncodeUsingEncoding:NSUTF8StringEncoding];
        	appaloosaService = [[OTAppaloosaUpdateService alloc] initWithDelegate:self];
        	[appaloosaService checkForUpdateWithStoreID:STORE_ID appID:bundleIDFormatted storeToken:STORE_TOKEN];

    4. Call the OTAppaloosaUpdateServiceDelegate method « updateIsAvailableOnAppaloosaStore »:

            - (void)updateIsAvailableOnAppaloosaStore
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update available" message:@"Would you like to update your application?" delegate:self cancelButtonTitle:@"Cancel"                             otherButtonTitles:@"Ok",nil];
                [alert show];
            }

    5. Call the AlertViewDelegate method « alert:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex » to validate or not the update:

            - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
            {
                if (buttonIndex == 0)
                {
                    NSLog(@"Cancel Update");
                }
                else if (buttonIndex == 1)
                {
                    [self.appaloosaService downloadNewVersionOfTheApp];
                }
            }

Add in-app-feedback to your app
---------------------------------

This SDK provides a fully integrated solution to send feedback to your dev team. In your appDelegate file, add the following line: 

	 [[OTAppaloosaActionButtonsManager sharedManager] initializeDefaultFeedbackButtonWithPosition:kAppaloosaButtonPositionRightBottom forRecipientsEmailArray:@[@"e.mail@address.com"]];
	
You have 2 possible positions for the default feedback button :
    * kAppaloosaButtonPositionRightBottom
    * kAppaloosaButtonPositionBottomRight


If you prefer to use your own button/action to trigger feedback, you can use the following line: 

 	[[OTAppaloosaActionButtonsManager sharedManager] presentFeedbackWithRecipientsEmailArray:@[@"e.mail@address.com"]];


To see how to use this feature, take a look at the Example/OTAppaloosaDemo/ project.

Add the dev panel to your app
---------------------------------

This SDK provides also a dev panel which gives information about the device and the application. In your appDelegate file, add the following line:

     	 [[OTAppaloosaActionButtonsManager sharedManager] initializeDefaultDevPanelButtonWithPosition:kAppaloosaButtonPositionRightBottom];


You have 2 possible positions for the default dev-panel button :
    * kAppaloosaButtonPositionRightBottom
    * kAppaloosaButtonPositionBottomRight


If you prefer to use your own button/action to trigger the dev panel, you can use the following line:

    	 [[OTAppaloosaActionButtonsManager sharedManager] presentDevPanel];


To see how to use this feature, take a look at the Example/OTAppaloosaDemo/ project.

Want some documentation?
------------------------

Appaloosa SDK for iOS use [AppleDoc](https://github.com/tomaz/appledoc) to generate its API's documentation.

License
-------

  Copyright (C) 2012 Octo Technology (http://www.octo.com)
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
       
       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.