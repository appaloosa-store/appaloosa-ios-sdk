//
//  OTAppaloosaInAppFeedbackViewController.m
//  OTInAppFeedback
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaInAppFeedbackViewController.h"



// Misc :
#import <QuartzCore/QuartzCore.h>

// Utils :
#import "NSObject+performBlockAfterDelay.h"


@interface OTAppaloosaInAppFeedbackViewController ()

- (void)updateMainScrollViewContentSize;
- (void)initializeScreenshotImageViewSizeForScreenHeight:(CGFloat)screenHeight;
- (void)initializeBorderForView:(UIView *)view;
- (void)initializeScreenshotViews;
- (void)initializeTitleAndDescriptionViews;
- (void)hideKeyboard;

- (void)openSendMailModalViewWithTitle:(NSString *)title
                           description:(NSString *)description
                    andScreenshotImage:(UIImage *)screenshotImage;

- (void)closeFeedbackViewController;
- (void)updateValidateButtonState;

- (CGFloat)statusBarHeight;

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


- (id)initWithFeedbackButton:(UIButton *)button recipientsEmailArray:(NSArray *)recipientsEmailArray andScreenshotImage:(UIImage *)screenshotImage
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
    [self.feedbackButton setHidden:YES];
    [self updateValidateButtonState];
    
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [self initializeScreenshotImageViewSizeForScreenHeight:[[UIScreen mainScreen] bounds].size.height];
    [self initializeTitleAndDescriptionViews];
    
    [self initializeScreenshotViews];
    
    [self.mainScrollView setDelegate:self];
    [self.mainScrollView setScrollsToTop:YES];
    [self updateMainScrollViewContentSize];
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.screenshotImageView.alpha == 0)
    {
        [self performBlock:^
         {
             [UIView animateWithDuration:kAnimationDuration animations:^
              {
                  [self.useScreenshotSwitch setOn:YES animated:NO];
                  [self onUseScreenshotSwitchChange:self.useScreenshotSwitch];
              }];
             
         } afterDelay:kAnimationDuration];
    }
    
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


- (IBAction)onSendButtonTap:(id)sender
{
    [self hideKeyboard];
    
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


- (void)initializeScreenshotImageViewSizeForScreenHeight:(CGFloat)screenHeight
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenshotHeight = CGRectGetWidth(self.screenshotImageView.frame) * (screenHeight - [self statusBarHeight]) / screenWidth;

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

- (void)initializeScreenshotViews
{
    // hide screenshot :
    [self.useScreenshotSwitch setOn:NO animated:NO];
    [self onUseScreenshotSwitchChange:self.useScreenshotSwitch];
    
    [self.screenshotImageView setImage:self.screenshotImage];
}

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


- (void)closeFeedbackViewController
{
    [self.feedbackButton setHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)updateValidateButtonState
{
    BOOL isTitleNotEmpty = ([self.titleTextField.text length] > 0);
    [self.validateButton setEnabled:isTitleNotEmpty];
}

- (CGFloat)statusBarHeight
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    return statusBarFrame.size.height;
}


@end
