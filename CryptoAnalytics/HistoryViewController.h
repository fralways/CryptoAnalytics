//
//  HistoryViewController.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 4/22/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnFilter;
@property (strong, nonatomic) IBOutlet UILabel *lblGainAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblGainText;

- (IBAction)filter:(UIButton *)sender;

@end
