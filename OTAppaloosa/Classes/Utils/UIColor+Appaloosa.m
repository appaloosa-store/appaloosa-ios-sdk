//
//  UIColor+Appaloosa.m
//  OTInAppFeedback
//
//  Created by Reda on 19/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "UIColor+Appaloosa.h"

@implementation UIColor (Appaloosa)

+ (UIColor *)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha
{
    return [UIColor
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            green:((float)((hexValue & 0xFF00) >> 8))/255.0
            blue:((float)(hexValue & 0xFF))/255.0
            alpha:alpha];
}

+ (UIColor *)appaloosaGreenColor
{
    return [self colorWithHexValue:0x9ec420 andAlpha:1.0];
}

+ (UIColor *)appaloosaDarkBlueColor
{
    return [self colorWithHexValue:0x041e3c andAlpha:1.0];
}


@end
