//
//  SetupStrategyConfigViewController.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupStrategyConfigViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnReset;
@property (strong, nonatomic) IBOutlet UIButton *btnFinish;
@property (strong, nonatomic) IBOutlet UISwitch *switchAuto;

- (IBAction)reset:(id)sender;
- (IBAction)finish:(id)sender;

@end
