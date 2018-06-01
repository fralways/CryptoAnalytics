//
//  SetupChooseStrategyViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "SetupChooseStrategyViewController.h"
#import "SetupStrategyConfigViewController.h"

@interface SetupChooseStrategyViewController ()

@end

@implementation SetupChooseStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self setupGraphics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)setupGraphics{
    self.view.backgroundColor = AppStyle.primaryLightColor;
    self.lblTitle.textColor = AppStyle.primaryTextColor;
    [self.btnNext setTintColor:AppStyle.primaryDarkColor];
}

#pragma mark - Picker\

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = @"";
    switch (row) {
        case 0:
            title = @"SPEED";
            break;
        case 1:
            title = @"MACD";
            break;
        case 2:
            title = @"SMA";
            break;
        case 3:
            title = @"EMA";
            break;
        default:
            break;
    }
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:AppStyle.primaryTextColor}];

    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (row) {
        case 0:
            [Context sharedContext].setupParams.strategy = SPEED;
            break;
        case 1:
            [Context sharedContext].setupParams.strategy = MACD;
            break;
        case 2:
            [Context sharedContext].setupParams.strategy = SMA;
            break;
        case 3:
            [Context sharedContext].setupParams.strategy = EMA;
            break;
        default:
            break;
    }
}

#pragma mark - Buttons
 
- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:STATIC_SEGUE_SETUPTOSTRATEGYCONFIG sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
