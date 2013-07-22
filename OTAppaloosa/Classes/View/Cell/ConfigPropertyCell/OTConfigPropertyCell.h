//
//  OTConfigPropertyCell.h
//  OTInAppFeedback
//
//  Created by Reda on 19/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTAppaloosaConfigProperty;

@interface OTConfigPropertyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyValue;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (OTConfigPropertyCell *)cell;
- (void)configureCellWithConfigProperty:(OTAppaloosaConfigProperty *)configProperty atIndexPath:(NSIndexPath *)indexPath;

@end
