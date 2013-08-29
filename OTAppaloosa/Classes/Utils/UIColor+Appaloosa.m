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
//  UIColor+Appaloosa.m
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
