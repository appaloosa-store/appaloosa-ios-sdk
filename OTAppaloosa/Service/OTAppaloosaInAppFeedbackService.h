//
//  OTAppaloosaInAppFeedbackService.h
//  OTFeedback
//
//  Created by Maxence Walbrou on 06/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAppaloosaInAppFeedbackService : NSObject


/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (strong, nonatomic) NSArray *recipientsEmailArray;


/**************************************************************************************************/
#pragma mark - UI

+ (void)showDefaultFeedbackButton:(BOOL)shouldShow;


/**************************************************************************************************/
#pragma mark - Feedback

- (void)initializeDefaultFeedbackButtonForRecipientsEmailArray:(NSArray *)emailsArray;
+ (void)triggerFeedbackWithRecipientsEmailArray:(NSArray *)emailsArray;


@end
