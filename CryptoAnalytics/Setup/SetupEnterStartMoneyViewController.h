//
//  SetupEnterStartMoneyViewController.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupEnterStartMoneyViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtMoney;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)next:(id)sender;

@end
