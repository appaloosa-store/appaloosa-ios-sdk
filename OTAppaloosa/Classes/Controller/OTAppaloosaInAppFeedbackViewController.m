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
//  OTAppaloosaInAppFeedbackViewController.m
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaInAppFeedbackViewController.h"



// Misc :
#import <QuartzCore/QuartzCore.h>

// Utils :
#import "UIViewController+CurrentPresentedController.h"


@interface OTAppaloosaInAppFeedbackViewController ()

- (void)updateMainScrollViewContentSize;
- (void)initializeScreenshotImageViewFrame;
- (void)initializeBorderForView:(UIView *)view;
- (void)initializeScreenshotViewWithImage:(UIImage *)image;
- (void)initializeTitleAndDescriptionViews;
- (void)hideKeyboard;

- (void)openSendMailModalViewWithTitle:(NSString *)title
                           description:(NSString *)description
                    andScreenshotImage:(UIImage *)screenshotImage;

- (void)closeFeedbackViewController;
- (void)updateValidateButtonState;

@end


// Constants :

static const CGFloat kScreenshotBottomMargin = 7;
static const CGFloat kTitleTextFieldLeftMargin = 6;
static const CGFloat kRoundedCornerRadius = 8;

static const CGFloat kAnimationDuration = 0.4;

static NSString * const kTitlePlaceholder = @"Title *";
static NSString * const kDescriptionPlaceholder = @"Description";
static NSString * const kScreenshotFileName = @"screenshot";
static NSString * const kInAppFeedbackPreTitle = @"[In-app feedback]";



@implementation OTAppaloosaInAppFeedbackViewController



/**************************************************************************************************/
#pragma mark - Birth & Death


- (id)initWithFeedbackButton:(UIButton *)button
        recipientsEmailArray:(NSArray *)recipientsEmailArray
          andScreenshotImage:(UIImage *)screenshotImage
{
    self = [super init];
    if (self)
    {
        self.recipientsEmailArray = recipientsEmailArray;
        self.screenshotImage = screenshotImage;
        self.feedbackButton = button;
    }
    return self;
}



/**************************************************************************************************/
#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:kAnimationDuration animations:^
    {
         [self.feedbackButton setAlpha:0];
    }];
    [self updateValidateButtonState];
    
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self initializeTitleAndDescriptionViews];
    
    [self initializeScreenshotViewWithImage:self.screenshotImage];
    
    [self.mainScrollView setDelegate:self];
    [self.mainScrollView setScrollsToTop:YES];
    [self updateMainScrollViewContentSize];
    
    [super viewDidAppear:animated];
}


/**************************************************************************************************/
#pragma mark - IBActions

- (IBAction)onCancelButtonTap:(id)sender
{
    [self closeFeedbackViewController];
}


- (IBAction)onUseScreenshotSwitchChange:(UISwitch *)sender
{
        // hide or show screenshot imageView switch change :
    BOOL shouldUseScreenshot = sender.on;
    
    [UIView animateWithDuration:kAnimationDuration animations:^
    {
        CGFloat alpha = (shouldUseScreenshot ? 1 : 0);
        [self.screenshotImageView setAlpha:alpha];
    }
    completion:^(BOOL finished)
    {
        [self updateMainScrollViewContentSize];
    }];
}


- (IBAction)onValidateButtonTap:(id)sender
{
    [self hideKeyboard];
    
    // get feedback title, description and image :
    NSString *feedbackType = [self.feedbackTypeSegmentedControl titleForSegmentAtIndex:self.feedbackTypeSegmentedControl.selectedSegmentIndex];
    NSString *title = [NSString stringWithFormat:@"%@ %@ : %@", kInAppFeedbackPreTitle, feedbackType, self.titleTextField.text];
    UIImage *screenshotImage = (self.useScreenshotSwitch.on ? self.screenshotImage : nil);
    
    [self openSendMailModalViewWithTitle:title
                             description:self.descriptionTextView.text
                      andScreenshotImage:screenshotImage];
}


- (IBAction)onTitleEditingChange:(id)sender
{
    [self updateValidateButtonState];
}


/**************************************************************************************************/
#pragma mark - UIScrollViewDelegate methods 

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}


/**************************************************************************************************/
#pragma mark - UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.descriptionTextView becomeFirstResponder];
    return YES;
}


/**************************************************************************************************/
#pragma mark - MFMailComposeViewControllerDelegate methods 

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // animate mail controller dismiss only if feedback is finished (because double animated dismiss do not work) :
    BOOL isFeedbackFinished = (result == MFMailComposeResultSaved || result == MFMailComposeResultSent);
    [controller dismissModalViewControllerAnimated:!isFeedbackFinished];
    
    if (isFeedbackFinished)
    {
        [self closeFeedbackViewController]; // second dismiss is done here
    }
}

/**************************************************************************************************/
#pragma mark - UITextViewDelegate methods 

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // remove empty lines at end of description :
    NSString *description = self.descriptionTextView.text;
    BOOL isDescriptionNotEmpty = ([description length] > 0);
    
    if (isDescriptionNotEmpty)
    {
        while ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[description characterAtIndex:[description length] - 1]])
        {
            description = [description substringToIndex:([description length] - 1)];
            [self.descriptionTextView setText:description];
        }
    }
}

/**************************************************************************************************/
#pragma mark - Private

- (void)updateMainScrollViewContentSize
{
    // calculate max height (switch screenshot is used or not) :
    CGFloat maxHeight = CGRectGetMaxY(self.screenshotImageView.frame);
    if (self.screenshotImageView.alpha == 0)
    {
        maxHeight = CGRectGetMinY(self.screenshotImageView.frame);
    }
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame), maxHeight + kScreenshotBottomMargin);
    
    [UIView animateWithDuration:kAnimationDuration animations:^
    {
        [self.mainScrollView setContentSize:size];
    }];
}



- (void)initializeScreenshotImageViewFrame
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    BOOL isInLandscapeMode = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    if (isInLandscapeMode)
    {
        CGFloat temp = screenHeight;
        screenHeight = screenWidth - CGRectGetHeight(self.navigationBar.frame);
        screenWidth = temp;
    }
    CGFloat screenshotHeight = screenHeight * CGRectGetWidth(self.screenshotImageView.frame) / screenWidth;

    CGRect frame = self.screenshotImageView.frame;
    frame.size.height = screenshotHeight;
    self.screenshotImageView.frame = frame;
}


- (void)initializeBorderForView:(UIView *)view
{
    view.layer.cornerRadius = kRoundedCornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.borderColor=[[UIColor grayColor] CGColor];
    view.layer.borderWidth= 1;
}


/**
 * @brief Initialize screenshot imageView frame and set its image
 * @param image
 */
- (void)initializeScreenshotViewWithImage:(UIImage *)image
{
    [self initializeScreenshotImageViewFrame];
    
    // set screenshotImageView image with fade in effect :
    [self.screenshotImageView setAlpha:0];
    [self.screenshotImageView setImage:image];
    [UIView animateWithDuration:kAnimationDuration animations:^
    {
        [self.screenshotImageView setAlpha:1];
    }];
}


/**
 * @brief Initialize title and description placeholders, backgrounds and borders
 */
- (void)initializeTitleAndDescriptionViews
{
    // set placeholders :
    [self.titleTextField setPlaceholder:kTitlePlaceholder];
    [self.descriptionTextView setPlaceholder:kDescriptionPlaceholder];
    
    [self.titleTextField setDelegate:self];
    [self.descriptionTextView setDelegate:self];
    
    // textfield style :
    [self.titleTextField setBackgroundColor:[UIColor whiteColor]];
    [self.titleTextField setBorderStyle:UITextBorderStyleNone];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTitleTextFieldLeftMargin, CGRectGetHeight(self.titleTextField.frame))];
    self.titleTextField.leftView = paddingView;
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // both views borders :
    [self initializeBorderForView:self.titleTextField];
    [self initializeBorderForView:self.descriptionTextView];
}


- (void)hideKeyboard
{
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}


- (void)openSendMailModalViewWithTitle:(NSString *)title
                           description:(NSString *)description
                    andScreenshotImage:(UIImage *)screenshotImage
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:title];
    
    // Set up recipients
    NSArray *toRecipients = self.recipientsEmailArray;
    [picker setToRecipients:toRecipients];
    
    if (screenshotImage)
    {
        // Attach an image to the email
        NSData *imageData = UIImageJPEGRepresentation(screenshotImage, 1.0);
        [picker addAttachmentData:imageData mimeType:@"image/png" fileName:kScreenshotFileName];
    }
    
    // Fill out the email body text
    NSString *emailBody = description;
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
}


/**
 * @brief Close this (self) viewController and set default feedback button alpha to 1
 */
- (void)closeFeedbackViewController
{
    [UIView animateWithDuration:kAnimationDuration animations:^
    {
        [self.feedbackButton setAlpha:1];
    }];
    [self dismissModalViewControllerAnimated:YES];
}


/**
 * @brief Enable or disable validate button switch title is empty or not
 */
- (void)updateValidateButtonState
{
    BOOL isTitleNotEmpty = ([self.titleTextField.text length] > 0);
    [self.validateButton setEnabled:isTitleNotEmpty];
}


- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [super viewDidUnload];
}
@end
