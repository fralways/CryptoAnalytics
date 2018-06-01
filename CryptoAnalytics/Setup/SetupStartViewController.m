//
//  SetupStartViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "SetupStartViewController.h"
#import "SetupParams.h"
#import "SetupEnterStartMoneyViewController.h"

@interface SetupStartViewController ()

@end

@implementation SetupStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGraphics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)setupGraphics{
    self.view.backgroundColor = AppStyle.primaryLightColor;
    self.lblHello.textColor = AppStyle.primaryTextColor;
    self.lblSubtitle.textColor = AppStyle.primaryTextColor;
    [self.btnNext setTintColor:AppStyle.primaryDarkColor];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
