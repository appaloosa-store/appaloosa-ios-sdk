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
#import "UIViewController+CurrentPresentedController.h"


// Constants :
static const CGFloat kFeedbackButtonTopMargin = 70;

static const CGFloat kFeedbackButtonWidth = 34;
static const CGFloat kFeedbackButtonHeight = 41;

static const CGFloat kAnimationDuration = 0.9;

static const NSUInteger kFeedbackButtonTag = 1212; // arbitrary tag


@interface OTAppaloosaInAppFeedbackService ()

+ (UIImage *)getScreenshotImageFromCurrentScreen;
+ (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray andFeedbackButton:(UIButton *)feedbackButton;

+ (UIButton *)recoverFeedbackButtonFromWindow;

@end


@implementation OTAppaloosaInAppFeedbackService



/**************************************************************************************************/
#pragma mark - Birth & Death


- (id)init
{
    self = [super init];
    if (self)
    {      
        [self initializeDefaultFeedbackButton];        
    }
    return self;
}


/**************************************************************************************************/
#pragma mark - UI

+ (void)showDefaultFeedbackButton:(BOOL)shouldShow
{
    UIButton *feedbackButton = [OTAppaloosaInAppFeedbackService recoverFeedbackButtonFromWindow];
    [feedbackButton setHidden:!shouldShow];
}


/**************************************************************************************************/
#pragma mark - IBActions

- (void)onFeedbackButtonTap
{
    [OTAppaloosaInAppFeedbackService triggerFeedbackWithRecipientsEmailArray:self.recipientsEmailArray
                                                           andFeedbackButton:[OTAppaloosaInAppFeedbackService recoverFeedbackButtonFromWindow]];
}


/**************************************************************************************************/
#pragma mark - Feedback 

- (void)initializeDefaultFeedbackButtonForRecipientsEmailArray:(NSArray *)emailsArray
{
    self.recipientsEmailArray = emailsArray;
    [OTAppaloosaInAppFeedbackService showDefaultFeedbackButton:YES];
}


+ (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray
{
    UIButton *feedbackButton = [OTAppaloosaInAppFeedbackService recoverFeedbackButtonFromWindow];
    [OTAppaloosaInAppFeedbackService triggerFeedbackWithRecipientsEmailArray:emailsArray andFeedbackButton:feedbackButton];
}


+ (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray andFeedbackButton:(UIButton *)feedbackButton
{
    // take screenshot :
    UIImage *screenshotImage = [OTAppaloosaInAppFeedbackService getScreenshotImageFromCurrentScreen];
    
    // display white blink screen (to copy iOS screenshot effect) before opening feedback controller :
    UIView *whiteView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    UIWindow *applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    [applicationWindow addSubview:whiteView];
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
         [[UIViewController currentPresentedController] presentModalViewController:feedbackViewController animated:YES];
     }];
}

/**************************************************************************************************/
#pragma mark - Private


- (void)initializeDefaultFeedbackButton
{
    UIWindow *applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect feedbackButtonFrame = CGRectMake(applicationWindow.frame.size.width - kFeedbackButtonWidth,
                                            kFeedbackButtonTopMargin,
                                            kFeedbackButtonWidth,
                                            kFeedbackButtonHeight);
    UIButton *feedbackButton = [[UIButton alloc] initWithFrame:feedbackButtonFrame];
    [feedbackButton setImage:[UIImage imageNamed:@"btn_feedback"] forState:UIControlStateNormal];
    [feedbackButton addTarget:self action:@selector(onFeedbackButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [feedbackButton setTag:kFeedbackButtonTag];
    [feedbackButton setHidden:YES]; // button is hidden by default
    
    [applicationWindow addSubview:feedbackButton];
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


+ (UIButton *)recoverFeedbackButtonFromWindow
{
    UIWindow *applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    UIButton *button = (UIButton *)[applicationWindow viewWithTag:kFeedbackButtonTag];
    return button;
}


@end
