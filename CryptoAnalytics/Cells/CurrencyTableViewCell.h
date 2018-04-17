//
//  CurrencyTableViewCell.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imgCurrency;

@end
