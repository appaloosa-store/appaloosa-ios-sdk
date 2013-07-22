//
//  OTConfigPropertyCell.m
//  OTInAppFeedback
//
//  Created by Reda on 19/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTConfigPropertyCell.h"
#import "OTAppaloosaConfigProperty.h"

CGFloat const kConfigPropertyCellHeight = 72.0f;

@implementation OTConfigPropertyCell

+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

+ (NSInteger)cellHeight
{
    return kConfigPropertyCellHeight;
}

- (NSString *)reuseIdentifier
{
    return [[self class] cellIdentifier];
}

+ (OTConfigPropertyCell *)cell
{
    __block OTConfigPropertyCell *cell = nil;
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[self class]])
        {
            cell = [(OTConfigPropertyCell *)obj initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[cell reuseIdentifier]];
        }
    }];
    
    return cell;
}

- (void)configureCellWithConfigProperty:(OTAppaloosaConfigProperty *)configProperty atIndexPath:(NSIndexPath *)indexPath
{
    self.propertyLabel.text = configProperty.label;
    self.propertyValue.text = configProperty.value;
}

@end
