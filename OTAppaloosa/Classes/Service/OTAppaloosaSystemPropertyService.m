//
//  OTAppaloosaSystemPropertyService.m
//  OTInAppFeedback
//
//  Created by Reda on 18/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <sys/utsname.h>
#import "OTAppaloosaSystemPropertyService.h"
#import "OTAppaloosaConfigProperty.h"

#include <stdio.h>

NSString * const kAppaloosaDevRegionPropertyLabel = @"Bundle Development Region";
NSString * const kAppaloosaExecutablePropertyLabel = @"Bundle Executable";
NSString * const kAppaloosaIdentifierPropertyLabel = @"Bundle Identifier";
NSString * const kAppaloosaNamePropertyLabel = @"Bundle Name";
NSString * const kAppaloosaPackageTypePropertyLabel = @"Bundle Package Type";
NSString * const kAppaloosaVersionPropertyLabel = @"Bundle Version";
NSString * const kAppaloosaSignaturePropertyLabel = @"Bundle Signature";
NSString * const kAppaloosaRequiredDeviceCapabilitiesPropertyLabel = @"Required Device Capabilities";
NSString * const kAppaloosaModelPropertyLabel = @"Model";
NSString * const kAppaloosaOSVersionPropertyLabel = @"iOS version";
NSString * const kAppaloosaIsJailbrokenPropertyLabel = @"Jailbroken device";

NSString * const kAppaloosaDevRegionPropertyValue = @"CFBundleDevelopmentRegion";
NSString * const kAppaloosaExecutablePropertyValue = @"CFBundleExecutable";
NSString * const kAppaloosaIdentifierPropertyValue = @"CFBundleIdentifier";
NSString * const kAppaloosaNamePropertyValue = @"CFBundleName";
NSString * const kAppaloosaPackageTypePropertyValue = @"CFBundlePackageType";
NSString * const kAppaloosaVersionPropertyValue = @"CFBundleVersion";
NSString * const kAppaloosaSignaturePropertyValue = @"CFBundleSignature";
NSString * const kAppaloosaRequiredDeviceCapabilitiesPropertyValue = @"UIRequiredDeviceCapabilities";

NSString * const kAppaloosaConfigPropertyUnknown = @"Unknown";
NSString * const kAppaloosaConfigPropertyPortrait = @"Portrait";
NSString * const kAppaloosaConfigPropertyPortraitUpsideDown = @"Portrait Upside Down";
NSString * const kAppaloosaConfigPropertyPaysageLeft = @"Paysage Left";
NSString * const kAppaloosaConfigPropertyPaysageRight = @"Paysage Right";

@implementation OTAppaloosaSystemPropertyService

/*****************************************************************************/
#pragma mark - Configuration

+ (NSDictionary *)configPropertyDictionary
{
    NSMutableArray *configPropertyMutableArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *bundlePropertyMutableDictionary = [[NSMutableDictionary alloc] init];
    
    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:kAppaloosaDevRegionPropertyLabel
                                                                       andBundleKey:kAppaloosaDevRegionPropertyValue]];
 
    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:kAppaloosaExecutablePropertyLabel
                                                                       andBundleKey:kAppaloosaExecutablePropertyValue]];
 
    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:kAppaloosaIdentifierPropertyLabel
                                                                       andBundleKey:kAppaloosaIdentifierPropertyValue]];
 
    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:kAppaloosaNamePropertyLabel
                                                                       andBundleKey:kAppaloosaNamePropertyValue]];
 
    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:kAppaloosaPackageTypePropertyLabel
                                                                       andBundleKey:kAppaloosaPackageTypePropertyValue]];

    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:kAppaloosaVersionPropertyLabel
                                                                       andBundleKey:kAppaloosaVersionPropertyValue]];

    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:kAppaloosaSignaturePropertyLabel
                                                                       andBundleKey:kAppaloosaSignaturePropertyValue]];

    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:kAppaloosaRequiredDeviceCapabilitiesPropertyLabel
                                                                       andBundleKey:kAppaloosaRequiredDeviceCapabilitiesPropertyValue]];
    
    [configPropertyMutableArray
     addObject:[OTAppaloosaSystemPropertyService orientationConfigProperty]];

    [bundlePropertyMutableDictionary setObject:[NSArray arrayWithArray:configPropertyMutableArray] forKey:@"Application"];

    [configPropertyMutableArray removeAllObjects];

    [configPropertyMutableArray addObject:[[OTAppaloosaConfigProperty alloc]
                                           initWithLabel:kAppaloosaModelPropertyLabel
                                           andValue:[OTAppaloosaSystemPropertyService deviceModel]]];
    
    [configPropertyMutableArray addObject:[[OTAppaloosaConfigProperty alloc]
                                           initWithLabel:kAppaloosaOSVersionPropertyLabel
                                           andValue:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]]]];
    
    [configPropertyMutableArray addObject:[[OTAppaloosaConfigProperty alloc]
                                           initWithLabel:kAppaloosaIsJailbrokenPropertyLabel
                                           andValue:([OTAppaloosaSystemPropertyService isJailbroken] ? @"YES" : @"NO")]];
    
    [bundlePropertyMutableDictionary setObject:[NSArray arrayWithArray:configPropertyMutableArray] forKey:@"Device"];
        
    return [NSDictionary dictionaryWithDictionary:bundlePropertyMutableDictionary];
}

/*****************************************************************************/
#pragma mark - Utils

+ (OTAppaloosaConfigProperty *)buildBundleConfigPropertyWithLabel:(NSString *)label andBundleKey:(NSString *)value
{
    NSBundle *appBundle = [NSBundle mainBundle];
    id appBundleValue;
    
    if ([appBundle objectForInfoDictionaryKey:value] == nil || [appBundle objectForInfoDictionaryKey:value] == NULL)
    {
        appBundleValue = kAppaloosaConfigPropertyUnknown;
    }
    else
    {
        appBundleValue = [appBundle objectForInfoDictionaryKey:value];
        if ([appBundleValue isKindOfClass:[NSArray class]] && [appBundleValue count] == 1)
            appBundleValue = [appBundleValue objectAtIndex:0];
    }
    
    return [[OTAppaloosaConfigProperty alloc]
            initWithLabel:label
            andValue:[NSString stringWithFormat:@"%@", appBundleValue]];
}

+ (NSString *)buildOrientationString:(NSString *)stringToBuild orientationLabel:(NSString *)orientation orientationCount:(NSInteger)count
{
    if (count == 0)
    {
        stringToBuild = orientation;
    }
    else if (count == 2)
    {
        [NSString stringWithFormat:@"%@ \n%@", stringToBuild, orientation];
    }
    else
    {
        [NSString stringWithFormat:@"%@ - %@", stringToBuild, orientation];
    }
    return stringToBuild;
}

+ (OTAppaloosaConfigProperty *)orientationConfigProperty
{
    
    OTAppaloosaConfigProperty *configProperty =
    [OTAppaloosaSystemPropertyService buildBundleConfigPropertyWithLabel:@"Supported Orientations"
                                                            andBundleKey:@"UISupportedInterfaceOrientations"];
    
    NSString *orientation = [[NSString alloc] init];
    NSInteger orientationCount = 0;
    
    if (configProperty.value == nil || configProperty.value == NULL
        || [configProperty.value length] == 0 || [configProperty.value isEqualToString:@"(\n)"]
        || [configProperty.value isEqualToString:@"(null)"])
    {
        orientation = [NSString stringWithFormat:@"%@ - %@\n%@ - %@", kAppaloosaConfigPropertyPortrait,
                                                                      kAppaloosaConfigPropertyPortraitUpsideDown,
                                                                      kAppaloosaConfigPropertyPaysageLeft,
                                                                      kAppaloosaConfigPropertyPaysageRight];
    }
    else
    {
        if ([configProperty.value rangeOfString:@"UIInterfaceOrientationPortrait"].location != NSNotFound) {
            orientation = [OTAppaloosaSystemPropertyService buildOrientationString:orientation
                                                                  orientationLabel:kAppaloosaConfigPropertyPortrait
                                                                  orientationCount:orientationCount];
            orientationCount++;
        }
        if ([configProperty.value rangeOfString:@"UIInterfaceOrientationPortraitUpsideDown"].location != NSNotFound) {
            orientation = [OTAppaloosaSystemPropertyService buildOrientationString:orientation
                                                                  orientationLabel:kAppaloosaConfigPropertyPortraitUpsideDown
                                                                  orientationCount:orientationCount];
            orientationCount++;
        }
        if ([configProperty.value rangeOfString:@"UIInterfaceOrientationLandscapeLeft"].location != NSNotFound) {
            orientation = [OTAppaloosaSystemPropertyService buildOrientationString:orientation
                                                                  orientationLabel:kAppaloosaConfigPropertyPaysageLeft
                                                                  orientationCount:orientationCount];
            orientationCount++;
        }
        if ([configProperty.value rangeOfString:@"UIInterfaceOrientationLandscapeRight"].location != NSNotFound) {
            orientation = [OTAppaloosaSystemPropertyService buildOrientationString:orientation
                                                                  orientationLabel:kAppaloosaConfigPropertyPaysageRight
                                                                  orientationCount:orientationCount];
            orientationCount++;
        }
    }
    
    configProperty.value = orientation;
    
    return configProperty;
}

+ (BOOL)isJailbroken
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else

    BOOL isJailbroken = NO;

    BOOL cydiaInstalled = [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
    FILE *f = fopen("/bin/bash", "r");
    
    if (!(errno == ENOENT) || cydiaInstalled)
    {
        isJailbroken = YES;
    }
    fclose(f);
    
    return isJailbroken;
#endif
}

/*
 * Content of the method from stackoverflow : http://stackoverflow.com/a/15719809
 */
+ (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *modelName = [NSString stringWithCString:systemInfo.machine
                                             encoding:NSUTF8StringEncoding];    
    
    //Simulator
    if([modelName isEqualToString:@"i386"] || [modelName isEqualToString:@"x86_64"]) {
        modelName = @"iPhone Simulator";
    }
    
    //iPhone
    else if([modelName isEqualToString:@"iPhone1,1"]) {
        modelName = @"iPhone";
    }
    else if([modelName isEqualToString:@"iPhone1,2"]) {
        modelName = @"iPhone 3G";
    }
    else if([modelName isEqualToString:@"iPhone2,1"]) {
        modelName = @"iPhone 3GS";
    }
    else if([modelName isEqualToString:@"iPhone3,1"]) {
        modelName = @"iPhone 4 (GSM)";
    }
    else if([modelName isEqualToString:@"iPhone3,2"]) {
        modelName = @"iPhone 4 GSM Rev A";
    }
    else if([modelName isEqualToString:@"iPhone3,3"]) {
        modelName = @"iPhone 4 (CDMA)";
    }
    else if([modelName isEqualToString:@"iPhone4,1"]) {
        modelName = @"iPhone 4S";
    }
    else if([modelName isEqualToString:@"iPhone5,1"]) {
        modelName = @"iPhone 5 (GSM)";
    }
    else if([modelName isEqualToString:@"iPhone5,2"]) {
        modelName = @"iPhone 5 (GSM+CDMA)";
    }
    
    //iPod touch
    else if([modelName isEqualToString:@"iPod1,1"]) {
        modelName = @"iPod touch 1G";
    }
    else if([modelName isEqualToString:@"iPod2,1"]) {
        modelName = @"iPod touch 2G";
    }
    else if([modelName isEqualToString:@"iPod3,1"]) {
        modelName = @"iPod touch 3G";
    }
    else if([modelName isEqualToString:@"iPod4,1"]) {
        modelName = @"iPod touch 4G";
    }
    else if([modelName isEqualToString:@"iPod5,1"]) {
        modelName = @"iPod touch 5G";
    }
    
    //iPad
    else if([modelName isEqualToString:@"iPad1,1"]) {
        modelName = @"iPad 1G";
    }
    else if([modelName isEqualToString:@"iPad2,1"]) {
        modelName = @"iPad 2 (WiFi)";
    }
    else if([modelName isEqualToString:@"iPad2,2"]) {
        modelName = @"iPad 2 (GSM)";
    }
    else if([modelName isEqualToString:@"iPad2,3"]) {
        modelName = @"iPad 2 (CDMA)";
    }
    else if([modelName isEqualToString:@"iPad2,4"]) {
        modelName = @"iPad 2 (WiFi + Rev A)";
    }
    else if([modelName isEqualToString:@"iPad3,1"]) {
        modelName = @"iPad 3 (WiFi)";
    }
    else if([modelName isEqualToString:@"iPad3,2"]) {
        modelName = @"iPad 3 (GSM+CDMA)";
    }
    else if([modelName isEqualToString:@"iPad3,3"]) {
        modelName = @"iPad 3 (GSM)";
    }
    else if([modelName isEqualToString:@"iPad3,4"]) {
        modelName = @"iPad 4 (WiFi)";
    }
    else if([modelName isEqualToString:@"iPad3,5"]) {
        modelName = @"iPad 4 (GSM)";
    }
    else if([modelName isEqualToString:@"iPad3,6"]) {
        modelName = @"iPad 4 (GSM+CDMA)";
    }
    
    //iPad mini
    else if([modelName isEqualToString:@"iPad2,5"]) {
        modelName = @"iPad mini (WiFi)";
    }
    else if([modelName isEqualToString:@"iPad2,6"]) {
        modelName = @"iPad mini (GSM)";
    }
    else if([modelName isEqualToString:@"iPad2,7"]) {
        modelName = @"iPad mini (GSM+CDMA)";
    }
    
    return modelName;
}

@end
