//
//  SetupStrategyConfigViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "SetupStrategyConfigViewController.h"
#import <KVNProgress/KVNProgress.h>
#import "Config.h"
#import "NetworkManager.h"

@interface SetupStrategyConfigViewController ()

@property Config *config;

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

#pragma mark - Network

- (void)patchConfig{
    [[NetworkManager sharedManager]getHomeWithCompletionHandler:^(bool successful, NSError *httpError) {
        if (successful){
            [[NetworkManager sharedManager]patchConfig:[self.config toDictionary] withCompletionHandler:^(bool successful, NSDictionary *config, NSError *httpError) {
                if (successful){
                    NSLog(@"SetupStrategyConfig: Patched successfully");
                }else{
                    NSLog(@"SetupStrategyConfig: Missing error handling");
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:STATIC_USERDEFAULTS_SETUPDONE];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [KVNProgress dismissWithCompletion:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:STATIC_SEGUE_SETUPTOMAIN sender:nil];
                        });
                    }];
                });
            }];
        }else{
            NSLog(@"SetupStrategyConfig: Missing home error handling");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:STATIC_USERDEFAULTS_SETUPDONE];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [KVNProgress dismissWithCompletion:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:STATIC_SEGUE_SETUPTOMAIN sender:nil];
                    });
                }];
            });
        }
    }];
}

#pragma mark - buttons

- (IBAction)reset:(id)sender {
    
}

- (IBAction)finish:(id)sender {
    [Context sharedContext].setupParams.automatic = self.switchAuto.isOn;
    [Context sharedContext].didSetup = YES;
    
    self.config = [Config new];
    [KVNProgress showWithStatus:@"Applying config"];
    self.config.selectedStrategy = [Context sharedContext].setupParams.strategy;
    self.config.setupIsOn = YES;
    [self patchConfig];
    
//    [self performSegueWithIdentifier:STATIC_SEGUE_SETUPTOMAIN sender:nil];
}

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:STATIC_SEGUE_SETUPTOSTRATEGYCONFIG sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
