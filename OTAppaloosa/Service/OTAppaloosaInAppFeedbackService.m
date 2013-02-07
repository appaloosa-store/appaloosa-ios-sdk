//
//  OTAppaloosaInAppFeedbackService.m
//  OTFeedback
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaInAppFeedbackService.h"


// Controllers :
#import "OTAppaloosaInAppFeedbackViewController.h"

// Misc :
#import <QuartzCore/QuartzCore.h>

// Utils :
#import "NSObject+performBlockAfterDelay.h"


// Constants :
static const CGFloat kFeedbackButtonTopMargin = 24;
static const CGFloat kFeedbackButtonRightMargin = 10;

static const CGFloat kFeedbackButtonWidth = 35;
static const CGFloat kFeedbackButtonHeight = 35;

static const CGFloat kAnimationDuration = 1;


@implementation OTAppaloosaInAppFeedbackService


/**************************************************************************************************/
#pragma mark - Getters and Setters

@synthesize feedbackButton = _feedbackButton;
@synthesize applicationWindow = _window;


/**************************************************************************************************/
#pragma mark - Birth & Death


- (id)initOnWindow:(UIWindow *)window
{
    self = [super init];
    if (self)
    {
        self.applicationWindow = window;
        
        // create feedback button :
        CGRect feedbackButtonFrame = CGRectMake(window.frame.size.width - kFeedbackButtonWidth - kFeedbackButtonRightMargin,
                                                kFeedbackButtonTopMargin,
                                                kFeedbackButtonWidth,
                                                kFeedbackButtonHeight);
        self.feedbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.feedbackButton setFrame:feedbackButtonFrame];
        [self.feedbackButton setTitle:@"F" forState:UIControlStateNormal];
        [self.feedbackButton setBackgroundColor:[UIColor redColor]];
        [self.feedbackButton setAlpha:0.5];
        [self.feedbackButton addTarget:self action:@selector(onFeedbackButtonTap) forControlEvents:UIControlEventTouchUpInside];
        
        [self showFeedbackButton:NO];
        
        [window addSubview:self.feedbackButton];
        
    }
    return self;
}


/**************************************************************************************************/
#pragma mark - UI

- (void)showFeedbackButton:(BOOL)shouldShow
{
    [self.feedbackButton setHidden:!shouldShow];
}



/**************************************************************************************************/
#pragma mark - IBActions

- (void)onFeedbackButtonTap
{
    // take screenshot :
    UIImage *screenshotImage = [self getScreenshotImageFromCurrentScreen];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.applicationWindow addSubview:whiteView];
    
    // make white screen (to copy iOS screenshot effect) :
    [UIView animateWithDuration:kAnimationDuration animations:^
    {
        [whiteView setAlpha:0];
    } completion:^(BOOL finished)
    {
         [whiteView removeFromSuperview];
    }];

    // open feedback
    [self performBlock:^
    {
        UIViewController *feedbackViewController = [[OTAppaloosaInAppFeedbackViewController alloc] initWithFeedbackButton:self.feedbackButton recipientsEmailArray:@[@"mwalbrou@octo.com"] andScreenshotImage:screenshotImage];
        
        [self.applicationWindow.rootViewController presentViewController:feedbackViewController
                                                                animated:YES
                                                              completion:^
         {
             [self.feedbackButton setHidden:YES];
         }];
        
    } afterDelay:kAnimationDuration];
}

/**************************************************************************************************/
#pragma mark - Private

- (UIImage *)getScreenshotImageFromCurrentScreen
{
    UIView *screenView = self.applicationWindow.rootViewController.view;
    CGRect rect = [screenView bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [[screenView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}


@end
