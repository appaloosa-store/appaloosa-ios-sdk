//
//  OTAppaloosaInAppFeedbackViewController.h
//  OTInAppFeedback
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <UIKit/UIKit.h>

// View :
#import "SSTextView.h"
#import "TPKeyboardAvoidingScrollView.h"

// Utils :
#import <MessageUI/MFMailComposeViewController.h>

@interface OTAppaloosaInAppFeedbackViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate>


/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (strong, nonatomic) UIButton *feedbackButton;
@property (strong, nonatomic) UIImage *screenshotImage;
@property (strong, nonatomic) NSArray *recipientsEmailArray;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet SSTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImageView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *validateButton;
@property (weak, nonatomic) IBOutlet UISwitch *useScreenshotSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *feedbackTypeSegmentedControl;


/**************************************************************************************************/
#pragma mark - Birth & Death


- (id)initWithFeedbackButton:(UIButton *)button recipientsEmailArray:(NSArray *)recipientsEmailArray andScreenshotImage:(UIImage *)screenshotImage;


@end
