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

@property (strong, nonatomic) UIButton *feedbackButton;
@property (strong, nonatomic) UIWindow *applicationWindow;



/**************************************************************************************************/
#pragma mark - Birth & Death

- (id)initOnWindow:(UIWindow *)window;


/**************************************************************************************************/
#pragma mark - UI

- (void)showFeedbackButton:(BOOL)shouldShow;


@end
