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
//  OTAppaloosaInAppFeedbackViewController.h
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

//@property (strong, nonatomic) UIButton *feedbackButton;
@property (strong, nonatomic) NSArray *appaloosaButtonsArray;
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


- (id)initWithAppaloosaButtons:(NSArray *)buttonsArray recipientsEmailArray:(NSArray *)recipientsEmailArray andScreenshotImage:(UIImage *)screenshotImage;


@end
