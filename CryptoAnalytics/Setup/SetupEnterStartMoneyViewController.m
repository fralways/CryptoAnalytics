//
//  SetupEnterStartMoneyViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "SetupEnterStartMoneyViewController.h"
#import "SetupChooseStrategyViewController.h"

@interface SetupEnterStartMoneyViewController ()

@end

@implementation SetupEnterStartMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupGraphics];
    self.txtMoney.delegate = self;
    [self.txtMoney becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)setupGraphics{
    self.view.backgroundColor = AppStyle.primaryLightColor;
    self.lblTitle.textColor = AppStyle.primaryTextColor;
    self.txtMoney.textColor = AppStyle.primaryTextColor;
    self.txtMoney.borderStyle = UITextBorderStyleNone;
    [self.btnNext setTintColor:AppStyle.primaryDarkColor];
    [self.txtMoney setTintColor:AppStyle.primaryTextColor];
}

#pragma mark - Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if (range.location == 0){
        return NO;
    }
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        return NO;
    }else{
        if (range.location == 1 && ![string isEqualToString:@""] && [string characterAtIndex:0] == '0'){
            return NO;
        }
    }

    if (range.location == 1 && [string isEqualToString:@""]){
        self.btnNext.enabled = NO;
    }else{
        self.btnNext.enabled = YES;
    }

    return YES;
}

#pragma mark - Buttons

- (IBAction)next:(id)sender {
    [Context sharedContext].setupParams.money = [self.txtMoney.text integerValue];
    [self performSegueWithIdentifier:STATIC_SEGUE_SETUPTOCHOOSESTRATEGY sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
