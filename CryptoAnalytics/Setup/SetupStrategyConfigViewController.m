//
//  SetupStrategyConfigViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "SetupStrategyConfigViewController.h"

@interface SetupStrategyConfigViewController ()

@end

@implementation SetupStrategyConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupGraphics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)setupGraphics{
    self.view.backgroundColor = AppStyle.primaryLightColor;
    self.tableView.backgroundColor = AppStyle.primaryLightColor;
    self.lblTitle.textColor = AppStyle.primaryTextColor;
    [self.btnReset setTintColor:AppStyle.primaryDarkColor];
    [self.btnFinish setTintColor:AppStyle.primaryDarkColor];
}

#pragma mark - buttons

- (IBAction)reset:(id)sender {
    
}

- (IBAction)finish:(id)sender {
    [Context sharedContext].setupParams.automatic = self.switchAuto.isOn;
    [Context sharedContext].didSetup = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:STATIC_USERDEFAULTS_SETUPDONE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:STATIC_SEGUE_SETUPTOMAIN sender:nil];
}

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:STATIC_SEGUE_SETUPTOSTRATEGYCONFIG sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
