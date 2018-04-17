//
//  CurrencyDetailsViewController.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/27/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"

@interface CurrencyDetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property Currency *currency;
@property (strong, nonatomic) IBOutlet UIView *chartArea;

@end
