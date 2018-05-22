//
//  ViewController.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 2/28/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CurrencyViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

+ (NSArray *)getCurrencies;

@end

