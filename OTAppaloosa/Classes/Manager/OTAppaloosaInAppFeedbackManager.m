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
//  OTAppaloosaInAppFeedbackManager.m
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaInAppFeedbackManager.h"


// Controllers :
#import "OTAppaloosaInAppFeedbackViewController.h"

// Misc :
#import <QuartzCore/QuartzCore.h>

// Utils :
#import "UIViewController+CurrentPresentedController.h"


// Constants :
static const CGFloat kFeedbackButtonTopMargin = 70;

static const CGFloat kFeedbackButtonWidth = 35;
static const CGFloat kFeedbackButtonHeight = 35;

static const CGFloat kAnimationDuration = 0.9;

@interface OTAppaloosaInAppFeedbackManager ()

- (void)onFeedbackButtonTap;

+ (UIImage *)getScreenshotImageFromCurrentScreen;
- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray andFeedbackButton:(UIButton *)feedbackButton;
+ (UIView *)getApplicationWindowView;

- (void)onOrientationChange;
- (void)updateFeedbackButtonFrame;

@end


@implementation OTAppaloosaInAppFeedbackManager


/**************************************************************************************************/
#pragma mark - Singleton

static OTAppaloosaInAppFeedbackManager *manager;

+ (OTAppaloosaInAppFeedbackManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

/**************************************************************************************************/
#pragma mark - Birth & Death


- (id)init
{
    self = [super init];
    if (self)
    {      
        [self initializeDefaultFeedbackButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**************************************************************************************************/
#pragma mark - UI

- (void)showDefaultFeedbackButton:(BOOL)shouldShow
{
    [self.feedbackButton setHidden:!shouldShow];
}


/**************************************************************************************************/
#pragma mark - IBActions

- (void)onFeedbackButtonTap
{
    [self triggerFeedbackWithRecipientsEmailArray:self.recipientsEmailArray
                                andFeedbackButton:self.feedbackButton];
}


/**************************************************************************************************/
#pragma mark - Feedback 

/**
 * @brief Create and display default feedback button
 * @param emailsArray - NSArray containing feedback e-mail(s) adresses
 */
- (void)initializeDefaultFeedbackButtonForRecipientsEmailArray:(NSArray *)emailsArray
{
    self.recipientsEmailArray = emailsArray;
    [self showDefaultFeedbackButton:YES];
}


/**
 * @brief Trigger screenshot + feedback viewController launch
 * @param emailsArray - NSArray containing feedback e-mail(s) adresses
 */
- (void)presentFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray
{
    [self triggerFeedbackWithRecipientsEmailArray:emailsArray andFeedbackButton:self.feedbackButton];
}


- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray andFeedbackButton:(UIButton *)feedbackButton
{
    // take screenshot :
    [self.feedbackButton setAlpha:0];
    UIImage *screenshotImage = [OTAppaloosaInAppFeedbackManager getScreenshotImageFromCurrentScreen];
    [self.feedbackButton setAlpha:1];
    
    // display white blink screen (to copy iOS screenshot effect) before opening feedback controller :
    UIView *whiteView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    UIView *windowView = [OTAppaloosaInAppFeedbackManager getApplicationWindowView];
    [windowView addSubview:whiteView];
    [UIView animateWithDuration:kAnimationDuration animations:^
     {
         [whiteView setAlpha:0];
     }
                     completion:^(BOOL finished)
     {
         [whiteView removeFromSuperview];
         
         // open feedback controller :
         OTAppaloosaInAppFeedbackViewController *feedbackViewController =
            [[OTAppaloosaInAppFeedbackViewController alloc] initWithFeedbackButton:feedbackButton
                                                              recipientsEmailArray:emailsArray
                                                                andScreenshotImage:screenshotImage];
         
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         {
             [feedbackViewController setModalPresentationStyle:UIModalPresentationFormSheet];
         }
         
         [[UIViewController currentPresentedController] presentModalViewController:feedbackViewController animated:YES];
     }];
}

/**************************************************************************************************/
#pragma mark - Private


/**
 * @brief Create the default feedback button and add it as subview on application window
 */
- (void)initializeDefaultFeedbackButton
{
    UIView *windowView = [OTAppaloosaInAppFeedbackManager getApplicationWindowView];

    self.feedbackButton = [[UIButton alloc] init];
    [self.feedbackButton setImage:[UIImage imageNamed:@"btn_feedback"] forState:UIControlStateNormal];
    [self.feedbackButton addTarget:self action:@selector(onFeedbackButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.feedbackButton setHidden:YES]; // button is hidden by default
    
    [windowView addSubview:self.feedbackButton];
    
    [self updateFeedbackButtonFrame];
}


+ (UIImage *)getScreenshotImageFromCurrentScreen
{
    UIView *viewToCopy = [[UIViewController currentPresentedController] view];
    CGRect rect = [viewToCopy bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [[viewToCopy layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenImage;
}

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

- (void)onOrientationChange
{
    [self updateFeedbackButtonFrame];
}


/**
 * @brief Update feedback button frame switch device orientation.
 */
- (void)updateFeedbackButtonFrame
{
    // hide button to prevent rotation glitch (button stays at the same place during rotation) :
    [self.feedbackButton setAlpha:0];
    
    // recover device orientation :
    UIView *windowView = [OTAppaloosaInAppFeedbackManager getApplicationWindowView];
    UIDeviceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isInLandscapeMode = (UIDeviceOrientationIsLandscape(currentOrientation));
    
    // calculate new origin point and rotation angle for feedback button switch orientation :
    CGFloat x;
    CGFloat y;
    CGFloat rotationAngle;
    if (isInLandscapeMode)
    {
        if (currentOrientation == UIDeviceOrientationLandscapeRight)
        {
            x = kFeedbackButtonTopMargin;
            y = 0;
            rotationAngle = -M_PI / 2;
        }
        else
        {
            x = windowView.frame.size.width - kFeedbackButtonTopMargin - kFeedbackButtonWidth;
            y = windowView.frame.size.height - kFeedbackButtonHeight;
            rotationAngle = M_PI / 2;
        }
    }
    else
    {
        if (currentOrientation == UIDeviceOrientationPortraitUpsideDown)
        {
            x = 0;
            y = windowView.frame.size.height - kFeedbackButtonTopMargin - kFeedbackButtonHeight;
            rotationAngle = M_PI;
        }
        else
        {
            x = windowView.frame.size.width - kFeedbackButtonWidth;
            y = kFeedbackButtonTopMargin;
            rotationAngle = 0;
        }
    }
    
    // apply new frame and rotation :
    CGRect feedbackButtonFrame = CGRectMake(x, y, kFeedbackButtonWidth, kFeedbackButtonHeight);
    self.feedbackButton.transform = CGAffineTransformIdentity;
    self.feedbackButton.frame = feedbackButtonFrame;
    self.feedbackButton.transform = CGAffineTransformMakeRotation(rotationAngle);
    
    // show button :
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.feedbackButton setAlpha:1];
    }];
}


@end
