//
//  OTAppaloosaDevPanelViewController.m
//  OTInAppFeedback
//
//  Created by Reda on 17/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import "OTAppaloosaDevPanelViewController.h"
#import "OTConfigPropertyCell.h"
#import "OTAppaloosaSystemPropertyService.h"
#import "OTAppaloosaConfigProperty.h"
#import "UIColor+Appaloosa.h"

CGFloat const kTableViewConfigPropertyHeaderHeight = 35.0f;
CGFloat const kAppaloosaDevPanelLabelHeight = 20.0f;
CGFloat const kAppaloosaDevPanelVCAnimation = 0.9f;

@implementation OTAppaloosaDevPanelViewController

- (id)initWithAppaloosaButtonsArray:(NSArray *)buttonsArray
{
    self = [super init];
    if (self)
    {
        self.appaloosaButtonsArray = buttonsArray;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:kAppaloosaDevPanelVCAnimation animations:^
     {
         for (UIButton *button in self.appaloosaButtonsArray)
         {
             [button setAlpha:0];
         }

     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appConfigPropertiesDictionary = [OTAppaloosaSystemPropertyService configPropertyDictionary];

    //ios5 empty cell fix
    [self.tableViewConfigProperty registerNib:[UINib nibWithNibName:NSStringFromClass([OTConfigPropertyCell class]) bundle:nil]
                    forCellReuseIdentifier:[OTConfigPropertyCell cellIdentifier]];
}

- (void)viewDidUnload
{
    [self setTableViewConfigProperty:nil];
    [super viewDidUnload];
}

/*****************************************************************************/
#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.appConfigPropertiesDictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = [self.appConfigPropertiesDictionary allKeys];
    return [(NSArray *)[self.appConfigPropertiesDictionary objectForKey:[keys objectAtIndex:section]] count];
}

- (OTConfigPropertyCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTConfigPropertyCell *cell = (OTConfigPropertyCell *)[tableView dequeueReusableCellWithIdentifier:[OTConfigPropertyCell cellIdentifier]];
    
    if (!cell)
    {
        cell = [OTConfigPropertyCell cell];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSArray *keys = [self.appConfigPropertiesDictionary allKeys];
    NSArray *properties = [self.appConfigPropertiesDictionary objectForKey:[keys objectAtIndex:indexPath.section]];
    OTAppaloosaConfigProperty *configProperty = [properties objectAtIndex:indexPath.row];
    
    if (configProperty != nil)
    {
        [cell configureCellWithConfigProperty:configProperty atIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OTConfigPropertyCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewConfigPropertyHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kTableViewConfigPropertyHeaderHeight)];
    headerView.backgroundColor = [UIColor appaloosaDarkBlueColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.bounds.size.width - 10, kAppaloosaDevPanelLabelHeight)];
    
    NSArray *keys = [self.appConfigPropertiesDictionary allKeys];

    label.text = (keys != nil && [keys count] > section) ? [keys objectAtIndex:section] : @"";
    
    label.textColor = [UIColor appaloosaGreenColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

/*****************************************************************************/
#pragma mark - Actions

- (IBAction)onCancelButtonTapped:(id)sender
{
    [self closeDevPanelViewController];
}

/*****************************************************************************/
#pragma mark - Utils

/**
 * @brief Close this (self) viewController and set default feedback button alpha to 1
 */
- (void)closeDevPanelViewController
{
    [UIView animateWithDuration:kAppaloosaDevPanelVCAnimation animations:^
     {
         for (UIButton *button in self.appaloosaButtonsArray)
         {
             [button setAlpha:1];
         }
     }];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
