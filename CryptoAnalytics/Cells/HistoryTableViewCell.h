//
//  HistoryTableViewCell.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 4/22/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@end
