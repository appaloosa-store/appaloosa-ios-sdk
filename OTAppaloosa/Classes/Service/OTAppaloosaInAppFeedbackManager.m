//
//  OTAppaloosaInAppFeedbackManager.m
//  OTFeedback
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
- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray
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
 * @return First window's view (to keep orientation when device rotates)
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


- (void)updateFeedbackButtonFrame
{
    [self.feedbackButton setAlpha:0];
    
    UIView *windowView = [OTAppaloosaInAppFeedbackManager getApplicationWindowView];
    UIDeviceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isInLandscapeMode = (UIDeviceOrientationIsLandscape(currentOrientation));
    
    CGFloat x;
    CGFloat y;
    CGFloat translationAngle;
    if (!isInLandscapeMode)
    {
        if (currentOrientation == UIDeviceOrientationPortraitUpsideDown)
        {
            x = 0;
            y = windowView.frame.size.height - kFeedbackButtonTopMargin - kFeedbackButtonHeight;
            translationAngle = M_PI;
        }
        else
        {
            x = windowView.frame.size.width - kFeedbackButtonWidth;
            y = kFeedbackButtonTopMargin;
            translationAngle = 0;
        }
    }
    else
    {
        if (currentOrientation == UIDeviceOrientationLandscapeRight)
        {
            x = kFeedbackButtonTopMargin;
            y = 0;
            translationAngle = -M_PI / 2;
        }
        else
        {
            x = windowView.frame.size.width - kFeedbackButtonTopMargin - kFeedbackButtonWidth;
            y = windowView.frame.size.height - kFeedbackButtonHeight;
            translationAngle = M_PI / 2;
        }
    }
    CGRect feedbackButtonFrame = CGRectMake(x, y, kFeedbackButtonWidth, kFeedbackButtonHeight);
    self.feedbackButton.transform = CGAffineTransformIdentity;
    self.feedbackButton.frame = feedbackButtonFrame;
    self.feedbackButton.transform = CGAffineTransformMakeRotation(translationAngle);
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.feedbackButton setAlpha:1];
    }];
}


@end
