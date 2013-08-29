Appaloosa SDK
=============

Overview
--------

Appaloosa SDK library is a simple library that helps you to:
 
* Auto-update your application stored on [Appaloosa Store](http://www.appaloosa-store.com/) server
* Receive feedback from your users directly from the app (iPhone and iPad)
* Launch a dev-panel giving information about the device and the application
* Authorizations for application

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

- Download and import OTAppaloosa sources and its dependencies : 
    - [TPKeyboardAvoiding](https://github.com/michaeltyson/TPKeyboardAvoiding).
    - [UIDeviceAddition](https://github.com/gekitz/UIDevice-with-UniqueIdentifier-for-iOS-5/tree/master/UIDeviceAddition).
    - [Reachability](https://github.com/tonymillion/Reachability).
    - [Base64](https://github.com/ekscrypto/Base64).
- Add OTAppaloosa sources to your project.


Configure Appaloosa Agent (NEW)
--------------------------------

Once the Appaloosa SDK integrated in your project, you need to configure the agent with the storeId and the storeToken.

- Register the Appaloosa Agent with your storeId and storeToken (you can find the storeId and storeToken on this page : http://www.appaloosa-store.com/settings).

    [[OTAppaloosaAgent sharedAgent] registerWithStoreId:APPALOOSA_STORE_ID
                                             storeToken:APPALOOSA_STORE_TOKEN
                                            andDelegate:self];

Check for application update - simple version (NEW)
----------------------------------------------------

In your AppDelegate.m file, launch the autoupdate when your application starts :
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. Register the Appaloosa Agent
    3. In method `- (void)applicationDidBecomeActive:(UIApplication *)application`, add the following code line:

        [[OTAppaloosaAgent sharedAgent] checkUpdates];
    
Check for application update - clever version (NEW)
----------------------------------------------------

1. Into your AppDelegate.h file
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. Add the OTAppaloosaAgentDelegate into your interface:

            @interface AppDelegate : UIResponder <UIApplicationDelegate, OTAppaloosaAgentDelegate>
            
2. Into your AppDelegate.m file, launch the autoupdate when your application starts :
    1. Register the Appaloosa Agent (storeId + storeToken)
    2. In method `- (void)applicationDidBecomeActive:(UIApplication *)application`, add the following code line:

        [[OTAppaloosaAgent sharedAgent] checkUpdates];
        
3. Implement delegate methods if you want your own behaviour :
    1. The method `- (void)applicationIsUpToDate` to be inform that the application is up to date. By default the application does nothing.
    2. The method `- (void)applicationIsNotUpToDateWithInstalledVersion:(NSString *)installedVersion andAppaloosaVersion:(NSString *)appaloosaVersion`to be inform that the application has to be updated. By default the SDK shows an alert view with the appropriated message and the possibility to download the new version.

Check for application update - simple version (DEPRECATED)
-----------------------------------------------------------

In your AppDelegate.m file, launch the autoupdate when your application starts :
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. In method `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`, add the following code line:

	[[OTAppaloosaSimpleUpdateService sharedInstance]checkForUpdateWithStoreID:STORE_ID storeToken:STORE_TOKEN];

Check for application update - clever version (DEPRECATED)
-----------------------------------------------------------

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

    [[OTAppaloosaAgent sharedAgent] feedbackControllerWithDefaultButtonAtPosition:kAppaloosaButtonPositionRightBottom forRecipientsEmailArray:@[@"e.mail@address.com"]];
	
You have 2 possible positions for the default feedback button :
* kAppaloosaButtonPositionRightBottom
* kAppaloosaButtonPositionBottomRight


If you prefer to use your own button/action to trigger feedback, you can use the following line: 

 	
    [[OTAppaloosaAgent sharedAgent] openFeedbackControllerWithRecipientsEmailArray:@[@"e.mail@address.com"]];


To see how to use this feature, take a look at the Example/OTAppaloosaDemo/ project.

Add the dev panel to your app
---------------------------------

This SDK provides also a dev panel which gives information about the device and the application. In your appDelegate file, add the following line:

     	 [[OTAppaloosaAgent sharedAgent] devPanelWithDefaultButtonAtPosition:kAppaloosaButtonPositionRightBottom];


You have 2 possible positions for the default dev-panel button :
* kAppaloosaButtonPositionRightBottom
* kAppaloosaButtonPositionBottomRight


If you prefer to use your own button/action to trigger the dev panel, you can use the following line:

    	 [[OTAppaloosaAgent sharedAgent] openDevPanelController];


To see how to use this feature, take a look at the Example/OTAppaloosaDemo/ project.

Check authorizations for application (NEW)
-------------------------------------------

This SDK provides a mecanism of kill switch. Since the web interface (http://www.appaloosa-store.com/), you are able to authorize or not a device to access to the application.

In your appDelegate file, add the following line to check authorizations:

    [[OTAppaloosaAgent sharedAgent] checkAuthorizations];
    
By default :
- if the user is authorized, nothing occurs.
- if the user is no authorized, an alert view is displayed with the appropriated message and the application is kill.

If you prefer develop your own behaviour, you should implement the `OTAppaloosaAgentDelegate` :
- to know if the user is authorized : `- (void)applicationAuthorizationsAllowed;`
- to know if the user is not authorized : `- (void)applicationAuthorizationsNotAllowedWithStatus:(OTAppaloosaAutorizationsStatus)status andMessage:(NSString *)message`

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