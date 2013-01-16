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

Simply add `pod 'AppaloosaAutoUpdate'` in your Podfile.

Refer to [CocoaPods](https://github.com/CocoaPods/CocoaPods) for more information about it.

How to integrate manually?
--------------------------

 1. Appaloosa AutoUpdate needs [JSONKit](https://github.com/johnezang/JSONKit).
 2. Import JSONKit into your project. JSONKit is not using ARC. Fix its project compiled options with `-fno-objc-arc`.
 3. Import into your project the following source files: *AppaloosaAutoUpdate.h*, *AppaloosaService.h*, *AppaloosaService.m*
 4. Into your AppDelegate.m file (launch of the autoupdate during application start)
    4.1. Import the plugin: `#import "AppaloosaAutoUpdate.h"`
    4.2. Into method `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`, add the following code line:
   
    [[AppaloosaService sharedInstance]checkForUpdateWithStoreID:VOTRE_STORE_ID storeToken:VOTRE_STORE_TOKEN];

Want some documentation?
------------------------

Appaloosa SDK for iOS use [AppleDoc](https://github.com/tomaz/appledoc) to generate its API's documentation.

Vous utilisez CocoaPods ?
-------------------------

Ajouter simplement `pod 'AppaloosaAutoUpdate'` dans votre fichier Podfile.

Plus d'informations sur [CocoaPods](https://github.com/CocoaPods/CocoaPods).

Comment l’intégrer dans un projet iOS ?
---------------------------------------

 1. l’AutoUpdate Appaloosa a besoin de [JSONKit](https://github.com/johnezang/JSONKit) (framework permettant de parser du JSON).
 2. Importer JSONKit dans le projet. Attention JSONKit n’est pas en ARC, veuillez le fixer en no arc dans la target de votre projet => build phases => compile sources => JSONKit.m => -fno-objc-arc
 3. Importer dans le projet les sources suivantes : AppaloosaAutoUpdate.h, AppaloosaService.h, AppaloosaService.m
 4. Dans l’AppDelegate.m (déclenchement de l’AutoUpdate au lancement de l’application)
    4.1. faire un import : #import "AppaloosaAutoUpdate.h"
    4.2. dans la fonction - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions , implémenter le code suivant : 
   
    [[AppaloosaService sharedInstance]checkForUpdateWithStoreID:VOTRE_STORE_ID     storeToken:VOTRE_STORE_TOKEN];

