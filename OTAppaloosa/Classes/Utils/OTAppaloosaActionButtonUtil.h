//
//  OTAppaloosaActionButton.h
//  OTInAppFeedback
//
//  Created by Reda on 18/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum AppaloosaButtonPosition
{
    kAppaloosaButtonPositionRightBottom = 0,
    kAppaloosaButtonPositionBottomRight = 1
} AppaloosaButtonPosition;

@interface OTAppaloosaActionButtonUtil : NSObject

+ (UIView *)getApplicationWindowView;
+ (void)updateButtonFrame:(UIButton *)button atPosition:(AppaloosaButtonPosition)position withRightMargin:(CGFloat)rightMargin andBottomMargin:(CGFloat)bottomMargin;

@end
