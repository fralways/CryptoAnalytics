//
//  SettingsViewController.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/27/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsTableViewCell.h"

@interface SettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SettingsTableViewCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end
