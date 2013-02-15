Appaloosa SDK
=============

Overview
--------

Appaloosa SDK library is a simple library that helps you to:

* Auto-update your application stored on [Appaloosa Store](http://www.appaloosa-store.com/) server.

Requirements
------------

Appaloosa SDK library use ARC.

Using CocoaPods?
----------------

Simply add `pod 'OTAppaloosa', :podspec => "https://raw.github.com/octo-online/appaloosa-ios-sdk/0.1.0/OTAppaloosa.podspec"` in your Podfile.

Refer to [CocoaPods](https://github.com/CocoaPods/CocoaPods) for more information about it.

How to integrate manually - quick version?
------------------------------------------

 1. Appaloosa AutoUpdate needs [JSONKit](https://github.com/johnezang/JSONKit).
 2. Import JSONKit into your project. JSONKit is not using ARC. Fix its project compiled options with `-fno-objc-arc`.
 3. Import into your project the following all source files.
 4. Into your AppDelegate.m file (launch of the autoupdate during application start)
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. Into method `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`, add the following code line:

            [[OTAppaloosaSimpleUpdateService sharedInstance]checkForUpdateWithStoreID:VOTRE_STORE_ID storeToken:VOTRE_STORE_TOKEN];

How to integrate manually - clever version?
-------------------------------------------

 1. Appaloosa AutoUpdate needs [JSONKit](https://github.com/johnezang/JSONKit).
 2. Import JSONKit into your project. JSONKit is not using ARC. Fix its project compiled options with `-fno-objc-arc`.
 3. Import into your project the following all source files.
 4. Into your AppDelegate.h file
    1. Add the OTAppaloosaUpdateServiceDelegate into your interface:

            @interface AppDelegate : UIResponder <UIApplicationDelegate, AppaloosaServiceDelegate>

    2. Add an OTAppaloosaUpdateService property:

            @property (nonatomic, strong) AppaloosaService *appaloosaService;

 5. Into your AppDelegate.m file (launch of the autoupdate during application start)
    1. Import the plugin: `#import "OTAppaloosa.h"`
    2. Add the OTAppaloosaUpdateService synthesize:

            @synthesize appaloosaService;

    3. Into method `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`, add the following code line:

        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSString *bundleIDFormatted = [bundleID urlEncodeUsingEncoding:NSUTF8StringEncoding];
        appaloosaService = [[OTAppaloosaUpdateService alloc] initWithDelegate:self];
        [appaloosaService checkForUpdateWithStoreID:VOTRE_STORE_ID appID:bundleIDFormatted storeToken:VOTRE_STORE_TOKEN];

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


Want some documentation?
------------------------

Appaloosa SDK for iOS use [AppleDoc](https://github.com/tomaz/appledoc) to generate its API's documentation.