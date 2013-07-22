//
//  OTAppaloosaDevPanelViewController.h
//  OTInAppFeedback
//
//  Created by Reda on 17/07/13.
//  Copyright (c) 2013 OCTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTAppaloosaDevPanelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableViewConfigProperty;
@property (nonatomic, strong) NSDictionary *appConfigPropertiesDictionary;
@property (strong, nonatomic) NSArray *appaloosaButtonsArray;

- (id)initWithAppaloosaButtonsArray:(NSArray *)buttonsArray;
- (IBAction)onCancelButtonTapped:(id)sender;

@end
