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

typedef enum FeedbackButtonPosition
{
    kFeedbackButtonPositionRightBottom = 0,
    kFeedbackButtonPositionBottomRight = 1
} FeedbackButtonPosition;


@interface OTAppaloosaInAppFeedbackManager : NSObject


/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (strong, nonatomic) UIButton *feedbackButton;
@property (strong, nonatomic) NSArray *recipientsEmailArray;

@property (assign, nonatomic) FeedbackButtonPosition feedbackButtonPosition;


/**************************************************************************************************/
#pragma mark - Singleton

+ (OTAppaloosaInAppFeedbackManager *)sharedManager;


/**************************************************************************************************/
#pragma mark - UI

- (void)showDefaultFeedbackButton:(BOOL)shouldShow;


/**************************************************************************************************/
#pragma mark - Feedback

/**
 * @brief Create and display default feedback button
 * @param position - button position in screen
 * @param emailsArray - NSArray containing feedback e-mail(s) adresses
 */
- (void)initializeDefaultFeedbackButtonWithPosition:(FeedbackButtonPosition)position forRecipientsEmailArray:(NSArray *)emailsArray;

/**
 * @brief Trigger screenshot + feedback viewController launch
 * @param emailsArray - NSArray containing feedback e-mail(s) adresses
 */
- (void)presentFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray;


@end
