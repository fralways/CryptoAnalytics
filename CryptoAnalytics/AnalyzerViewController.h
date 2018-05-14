//
//  AnalyzerViewController.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/27/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalyzerTableViewCell.h"

@interface AnalyzerViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, AnalyzerTableViewCellDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
