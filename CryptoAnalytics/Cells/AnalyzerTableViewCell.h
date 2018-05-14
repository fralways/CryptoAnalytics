//
//  AnalyzerTableViewCell.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/14/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnalyzerTableViewCellDelegate<NSObject>

@optional
- (void)actionClickedWithTag:(NSInteger)tag;

@end

@interface AnalyzerTableViewCell : UITableViewCell

@property (weak) id <AnalyzerTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrency;
@property (strong, nonatomic) IBOutlet UILabel *lblTimestamp;
@property (strong, nonatomic) IBOutlet UIButton *btnAction;

- (IBAction)btnAction:(UIButton *)sender;

@end
