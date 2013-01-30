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

Simply add `pod 'OTAppaloosa', :podspec => "https://raw.github.com/octo-online/appaloosa-ios-sdk/master/OTAppaloosa.podspec"` in your Podfile.

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

* * *

Vous utilisez CocoaPods ?
-------------------------

Ajouter simplement `pod 'AppaloosaAutoUpdate', :podspec => "https://raw.github.com/octo-online/appaloosa-ios-sdk/master/OTAppaloosa.podspec"` dans votre fichier Podfile.

Plus d'informations sur [CocoaPods](https://github.com/CocoaPods/CocoaPods).

Comment l’intégrer manuellement dans un projet iOS - quick version ?
--------------------------------------------------------------------

 1. l’AutoUpdate Appaloosa a besoin de [JSONKit](https://github.com/johnezang/JSONKit) (framework permettant de parser du JSON).
 2. Importer JSONKit dans le projet. Attention JSONKit n’est pas en ARC, veuillez le fixer en no arc dans la target de votre projet => build phases => compile sources => JSONKit.m => -fno-objc-arc
 3. Importer dans le projet les sources suivantes : AppaloosaAutoUpdate.h, AppaloosaService.h, AppaloosaService.m
 4. Dans l’AppDelegate.m (déclenchement de l’AutoUpdate au lancement de l’application)
    1. faire un import : #import "AppaloosaAutoUpdate.h"
    2. dans la fonction - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions , implémenter le code suivant : 

            [[AppaloosaService sharedInstance]checkForUpdateWithStoreID:VOTRE_STORE_ID storeToken:VOTRE_STORE_TOKEN];

Comment l’intégrer manuellement dans un projet iOS - clever version ?
---------------------------------------------------------------------

 1. l’AutoUpdate Appaloosa a besoin de JSONKit (framework permettant de parser du JSON) qui est dispo ici : https://github.com/johnezang/JSONKit 
 2. Importer JSONKit dans le projet. Attention JSONKit n’est pas en ARC, veuillez le fixer en no arc dans la target de votre projet => build phases => compile sources => JSONKit.m => -fno-objc-arc
 3. Importer dans le projet les sources suivantes : AppaloosaService.h, AppaloosaService.m, NSString+URLEncoding.h et NSString+URLEncoding.m
 4. Dans l’AppDelegate.h 
    1. Ajouter le delegate AppaloosaServiceDelegate dans l’interface : 

            @interface AppDelegate : UIResponder <UIApplicationDelegate, AppaloosaServiceDelegate>

    2. Ajouter une property AppaloosaService : 

            @property (strong, nonatomic) AppaloosaService *appaloosaService;

 5. Dans l’AppDelegate.m (déclenchement de l’AutoUpdate au lancement de l’application)
    1. Faire un import : #import "AppaloosaService.h"
    2. Ajouter la synthesize AppaloosaService :

            @synthesize appaloosaService;

    3. Dans la fonction - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions , implémenter le code suivant : 

            NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
            NSString *bundleIDFormatted = [bundleID urlEncodeUsingEncoding:NSUTF8StringEncoding];
            appaloosaService = [[AppaloosaService alloc] initWithDelegate:self];
            [appaloosaService checkForUpdateWithStoreID:VOTRE_STORE_ID appID:bundleIDFormatted storeToken:VOTRE_STORE_TOKEN];

    4. Faire appel à la méthode du delegate AppaloosaServiceDelegate « updateIsAvailableOnAppaloosaStore » :

            - (void)updateIsAvailableOnAppaloosaStore
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mise à jour disponible" message:@"Voulez vous mettre à jour Askbob Mobile ?" delegate:self cancelButtonTitle:@"Annuler"                             otherButtonTitles:@"Ok",nil];
                [alert show];
            }

    5. Faire appel à la méthode du delegate AlertViewDelegate « alertiez:(UIAlertView *)alertiez clickedButtonAtIndex:(NSInteger)buttonIndex », pour valider ou pas l’update :

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

