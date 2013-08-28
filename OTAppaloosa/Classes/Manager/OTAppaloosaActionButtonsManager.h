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
//  OTAppaloosaInAppFeedbackManager.h
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTAppaloosaActionButtonUtil.h"


@interface OTAppaloosaActionButtonsManager : NSObject


/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (strong, nonatomic) UIButton *devPanelButton;
@property (strong, nonatomic) UIButton *feedbackButton;

@property (strong, nonatomic) NSArray *recipientsEmailArray;

@property (assign, nonatomic) AppaloosaButtonPosition devPanelButtonPosition;
@property (assign, nonatomic) AppaloosaButtonPosition feedbackButtonPosition;


/**************************************************************************************************/
#pragma mark - Singleton

+ (OTAppaloosaActionButtonsManager *)sharedManager DEPRECATED_ATTRIBUTE;


/**************************************************************************************************/
#pragma mark - UI

- (void)showDefaultFeedbackButton:(BOOL)shouldShow;
- (void)showDefaultDevPanelButton:(BOOL)shouldShow;

/**************************************************************************************************/
#pragma mark - Feedback

/**
 * @brief Create and display default feedback button
 * @param position - button position in screen
 * @param emailsArray - NSArray containing feedback e-mail(s) adresses
 */
- (void)initializeDefaultFeedbackButtonWithPosition:(AppaloosaButtonPosition)position forRecipientsEmailArray:(NSArray *)emailsArray;

/**
 * @brief Create and display default dev panel button
 * @param position - button position in screen
 */
- (void)initializeDefaultDevPanelButtonWithPosition:(AppaloosaButtonPosition)position;

/**
 * @brief Trigger screenshot + feedback viewController launch
 * @param emailsArray - NSArray containing feedback e-mail(s) adresses
 */
- (void)presentFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray;

/**
 * @brief Dev panel viewController launch
 */
- (void)presentDevPanel;

@end
