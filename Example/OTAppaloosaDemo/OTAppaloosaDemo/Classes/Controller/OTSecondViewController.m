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
//
//  OTSecondViewController.m
//
//  Created by Maxence Walbrou on 08/02/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTSecondViewController.h"

@interface OTSecondViewController ()

@end


@implementation OTSecondViewController


/**************************************************************************************************/
#pragma mark - Birth & Death

- (id)initAsAModal:(BOOL)isModal
{
    self = [super init];
    if (self)
    {
        self.isModal = isModal;
    }
    return self;
}


/**************************************************************************************************/
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor redColor]];
    
    if (self.isModal)
    {        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        closeButton.frame = CGRectMake(0, 0, 60, 40);
        closeButton.center = self.view.center;
        [closeButton addTarget:self action:@selector(onCloseButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeButton];
    }
    
    [super viewDidLoad];
}


/**************************************************************************************************/
#pragma mark - IBActions

- (void)onCloseButtonTap:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
