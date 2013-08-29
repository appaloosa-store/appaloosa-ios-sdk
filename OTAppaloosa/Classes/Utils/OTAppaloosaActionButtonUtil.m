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
//  OTAppaloosaActionButton.m
//
//  Created by Reda on 18/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaActionButtonsManager.h"
#import "OTAppaloosaActionButtonUtil.h"

static const CGFloat kAppaloosaButtonWidth = 35;
static const CGFloat kAppaloosaButtonHeight = 35;
static const CGFloat kAnimationDuration = 0.9;

@interface OTAppaloosaActionButtonUtil (Private)

+ (UIView *)getApplicationWindowView;

@end

@implementation OTAppaloosaActionButtonUtil

/**
 * @return First window's view
 */
+ (UIView *)getApplicationWindowView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!window)
    {
        window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    
    return window;
}

/**
 * @brief Update feedback button frame switch device orientation.
 */
+ (void)updateButtonFrame:(UIButton *)button atPosition:(AppaloosaButtonPosition)position withRightMargin:(CGFloat)rightMargin andBottomMargin:(CGFloat)bottomMargin
{
    BOOL shouldShowButton = (button.alpha != 0);
    
    // hide button to prevent rotation glitch (button stays at the same place during rotation) :
    [button setAlpha:0];
    
    // recover device orientation :
    UIDeviceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isInLandscapeMode = (UIDeviceOrientationIsLandscape(currentOrientation));
    
    
    // calculate new origin point and rotation angle for feedback button switch orientation :
    CGPoint buttonCoordinates;
    CGFloat rotationAngle;
    if (isInLandscapeMode)
    {
        rotationAngle = [OTAppaloosaActionButtonUtil rotationAngleInLandscapeMode];
        buttonCoordinates = [OTAppaloosaActionButtonUtil originOnLandscapeMode:position
                                                                       withRightMargin:rightMargin
                                                                       andBottomMargin:bottomMargin];
    }
    else
    {
        rotationAngle = [OTAppaloosaActionButtonUtil rotationAngleInPortraitMode];
        buttonCoordinates = [OTAppaloosaActionButtonUtil originOnPortraitMode:position
                                                                       withRightMargin:rightMargin
                                                                       andBottomMargin:bottomMargin];
    }
    
    // apply new frame and rotation :
    CGRect feedbackButtonFrame = CGRectMake(buttonCoordinates.x, buttonCoordinates.y, kAppaloosaButtonWidth, kAppaloosaButtonHeight);
    button.transform = CGAffineTransformIdentity;
    button.frame = feedbackButtonFrame;
    button.transform = CGAffineTransformMakeRotation(rotationAngle);
    
    if (shouldShowButton)
    {
        // show button :
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [button setAlpha:1];
        }];
    }
}

+ (CGPoint)originOnLandscapeMode:(AppaloosaButtonPosition)position withRightMargin:(CGFloat)rightMargin andBottomMargin:(CGFloat)bottomMargin
{
    CGPoint buttonCoordinates;
    
    // recover device orientation :
    UIView *windowView = [OTAppaloosaActionButtonUtil getApplicationWindowView];
    UIDeviceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (currentOrientation == UIDeviceOrientationLandscapeRight)
    {
        if (position == kAppaloosaButtonPositionBottomRight)
        {
            buttonCoordinates.x = windowView.frame.size.width - kAppaloosaButtonHeight;
            buttonCoordinates.y = rightMargin;
        }
        else
        {
            buttonCoordinates.x = windowView.frame.size.width - bottomMargin - kAppaloosaButtonHeight;
            buttonCoordinates.y = 0;
        }
    }
    else
    {
        if (position == kAppaloosaButtonPositionBottomRight)
        {
            buttonCoordinates.x = 0;
            buttonCoordinates.y = windowView.frame.size.height - kAppaloosaButtonWidth - rightMargin;
        }
        else
        {
            buttonCoordinates.x = bottomMargin;
            buttonCoordinates.y = windowView.frame.size.height - kAppaloosaButtonWidth;
        }
    }
    
    return buttonCoordinates;
}

+ (CGPoint)originOnPortraitMode:(AppaloosaButtonPosition)position withRightMargin:(CGFloat)rightMargin andBottomMargin:(CGFloat)bottomMargin
{
    CGPoint buttonCoordinates;
    
    // recover device orientation :
    UIView *windowView = [OTAppaloosaActionButtonUtil getApplicationWindowView];
    UIDeviceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (currentOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        if (position == kAppaloosaButtonPositionBottomRight)
        {
            buttonCoordinates.x = rightMargin;
            buttonCoordinates.y = 0;
        }
        else
        {
            buttonCoordinates.x = 0;
            buttonCoordinates.y = bottomMargin;
        }
    }
    else
    {
        if (position == kAppaloosaButtonPositionBottomRight)
        {
            buttonCoordinates.x = windowView.frame.size.width - kAppaloosaButtonWidth - rightMargin;
            buttonCoordinates.y = windowView.frame.size.height - kAppaloosaButtonHeight;
        }
        else
        {
            buttonCoordinates.x = windowView.frame.size.width - kAppaloosaButtonWidth;
            buttonCoordinates.y = windowView.frame.size.height - bottomMargin - kAppaloosaButtonHeight;
        }
    }
    return buttonCoordinates;
}

+ (CGFloat)rotationAngleInLandscapeMode
{
    UIDeviceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return (currentOrientation == UIDeviceOrientationLandscapeRight) ? (-M_PI / 2) : (M_PI / 2);
}

+ (CGFloat)rotationAngleInPortraitMode
{
    UIDeviceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return (currentOrientation == UIDeviceOrientationPortraitUpsideDown) ? (M_PI) : (0);
}



@end
