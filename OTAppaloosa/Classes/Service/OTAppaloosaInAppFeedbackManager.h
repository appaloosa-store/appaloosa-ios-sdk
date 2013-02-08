//
//  OTAppaloosaInAppFeedbackManager.h
//  OTFeedback
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAppaloosaInAppFeedbackManager : NSObject


/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (strong, nonatomic) UIButton *feedbackButton;
@property (strong, nonatomic) NSArray *recipientsEmailArray;


/**************************************************************************************************/
#pragma mark - Singleton

+ (OTAppaloosaInAppFeedbackManager *)sharedManager;


/**************************************************************************************************/
#pragma mark - UI

- (void)showDefaultFeedbackButton:(BOOL)shouldShow;


/**************************************************************************************************/
#pragma mark - Feedback

- (void)initializeDefaultFeedbackButtonForRecipientsEmailArray:(NSArray *)emailsArray;
- (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray;


@end
