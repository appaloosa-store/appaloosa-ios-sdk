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
//  OTConfigPropertyCell.m
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
