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

#import "OTAppaloosaActionButtonsManager.h"

// Controllers :
#import "OTAppaloosaInAppFeedbackViewController.h"
#import "OTAppaloosaDevPanelViewController.h"

// Misc :
#import <QuartzCore/QuartzCore.h>

// Utils :
#import "UIViewController+CurrentPresentedController.h"
#import "OTAppaloosaActionButtonUtil.h"

// Constants :
static const CGFloat kFeedbackButtonRightMargin = 20;
static const CGFloat kFeedbackButtonBottomMargin = 60;

static const CGFloat kDevPanelButtonRightMargin = 10;
static const CGFloat kDevPanelButtonBottomMargin = 10;

static const CGFloat kAppaloosaFeedbackScreenshotAnimationDuration = 0.9;

@interface OTAppaloosaActionButtonsManager ()

- (void)initializeDefaultFeedbackButtonWithPosition:(AppaloosaButtonPosition)position;
- (void)initializeDefaultDevPanelButtonWithPosition:(AppaloosaButtonPosition)position;

- (void)onFeedbackButtonTap;

+ (UIImage *)getScreenshotImageFromCurrentScreen;
- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray andFeedbackButton:(UIButton *)feedbackButton;

- (void)onOrientationChange;

@end


@implementation OTAppaloosaActionButtonsManager


/**************************************************************************************************/
#pragma mark - Singleton

static OTAppaloosaActionButtonsManager *manager;

+ (OTAppaloosaActionButtonsManager *)sharedManager
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
    if (!self.feedbackButton)
    {
        NSLog(@"ERROR : Default feedback button must be initalized before changing its visibility");
    }
    else
    {
        [self.feedbackButton setHidden:!shouldShow];
    }
}

- (void)showDefaultDevPanelButton:(BOOL)shouldShow
{
    if (!self.devPanelButton)
    {
        NSLog(@"ERROR : Default dev panel button must be initalized before changing its visibility");
    }
    else
    {
        [self.devPanelButton setHidden:!shouldShow];
    }
}


/**************************************************************************************************/
#pragma mark - IBActions

- (void)onFeedbackButtonTap
{
    [self triggerFeedbackWithRecipientsEmailArray:self.recipientsEmailArray
                                andFeedbackButton:self.feedbackButton];
}

- (void)onDevPanelButtonTap
{
    [self presentDevPanel];
}

/*****************************************************************************/
#pragma mark - dev panel

/**
 * @brief Create the default dev panel button and add it as subview on application window
 */
- (void)initializeDefaultDevPanelButtonWithPosition:(AppaloosaButtonPosition)position
{
    UIView *windowView = [OTAppaloosaActionButtonUtil getApplicationWindowView];
    
    NSString *imageName = (position == kAppaloosaButtonPositionBottomRight ? @"btn_bottomDevPanel" : @"btn_rightDevPanel");
    self.devPanelButton = [self initializeButtonWithImageName:imageName andTargetSelector:@selector(onDevPanelButtonTap)];
    
    [windowView addSubview:self.devPanelButton];
    
    self.devPanelButtonPosition = position;
    [OTAppaloosaActionButtonUtil updateButtonFrame:self.devPanelButton
                                    atPosition:self.devPanelButtonPosition
                               withRightMargin:kDevPanelButtonRightMargin
                               andBottomMargin:kDevPanelButtonBottomMargin];
    [self showDefaultDevPanelButton:YES];
}

- (void)presentDevPanel
{
    NSArray *appaloosaButtons = [[NSArray alloc] initWithObjects:self.devPanelButton, self.feedbackButton, nil];
    
    OTAppaloosaDevPanelViewController *devControllerViewController =
    [[OTAppaloosaDevPanelViewController alloc] initWithAppaloosaButtonsArray:appaloosaButtons];
    
    [[UIViewController currentPresentedController] presentModalViewController:devControllerViewController animated:YES];
}

/**************************************************************************************************/
#pragma mark - Feedback

/**
 * @brief Create the default feedback button and add it as subview on application window
 */
- (void)initializeDefaultFeedbackButtonWithPosition:(AppaloosaButtonPosition)position
{
    UIView *windowView = [OTAppaloosaActionButtonUtil getApplicationWindowView];
    
    NSString *imageName = (position == kAppaloosaButtonPositionBottomRight ? @"btn_bottomFeedback" : @"btn_rightFeedback");
    self.feedbackButton = [self initializeButtonWithImageName:imageName andTargetSelector:@selector(onFeedbackButtonTap)];
    
    [windowView addSubview:self.feedbackButton];
    
    self.feedbackButtonPosition = position;
    
    [OTAppaloosaActionButtonUtil updateButtonFrame:self.feedbackButton
                                    atPosition:self.feedbackButtonPosition
                               withRightMargin:kFeedbackButtonRightMargin
                               andBottomMargin:kFeedbackButtonBottomMargin];
    
}

- (void)initializeDefaultFeedbackButtonWithPosition:(AppaloosaButtonPosition)position
                            forRecipientsEmailArray:(NSArray *)emailsArray
{
    [self initializeDefaultFeedbackButtonWithPosition:position];
    self.recipientsEmailArray = emailsArray;
    [self showDefaultFeedbackButton:YES];
}

- (void)presentFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray
{
    [self triggerFeedbackWithRecipientsEmailArray:emailsArray andFeedbackButton:self.feedbackButton];
}

- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray andFeedbackButton:(UIButton *)feedbackButton
{
    // take screenshot :
    [self.feedbackButton setAlpha:0];
    UIImage *screenshotImage = [OTAppaloosaActionButtonsManager getScreenshotImageFromCurrentScreen];
    [self.feedbackButton setAlpha:1];
    
    // display white blink screen (to copy iOS screenshot effect) before opening feedback controller :
    UIView *whiteView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    UIView *windowView = [OTAppaloosaActionButtonUtil getApplicationWindowView];
    [windowView addSubview:whiteView];
    [UIView animateWithDuration:kAppaloosaFeedbackScreenshotAnimationDuration animations:^{
         [whiteView setAlpha:0];
     } completion:^(BOOL finished) {
         
         [whiteView removeFromSuperview];
         
         NSArray *buttonsArray = [[NSArray alloc] initWithObjects:feedbackButton, self.devPanelButton, nil];
         
         // open feedback controller :
         OTAppaloosaInAppFeedbackViewController *feedbackViewController =
         [[OTAppaloosaInAppFeedbackViewController alloc] initWithAppaloosaButtons:buttonsArray
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

- (UIButton *)initializeButtonWithImageName:(NSString *)imageName andTargetSelector:(SEL)targetSelector
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:targetSelector forControlEvents:UIControlEventTouchUpInside];
    [button setHidden:YES]; // button is hidden by default

    return button;
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

- (void)onOrientationChange
{
    [OTAppaloosaActionButtonUtil updateButtonFrame:self.feedbackButton
                                    atPosition:self.feedbackButtonPosition
                               withRightMargin:kFeedbackButtonRightMargin
                               andBottomMargin:kFeedbackButtonBottomMargin];

    [OTAppaloosaActionButtonUtil updateButtonFrame:self.devPanelButton
                                    atPosition:self.devPanelButtonPosition
                               withRightMargin:kDevPanelButtonRightMargin
                               andBottomMargin:kDevPanelButtonBottomMargin];
}


@end
