//
//  StartViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "StartViewController.h"
#import "SetupStartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIViewController *vc;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:STATIC_USERDEFAULTS_SETUPDONE]){
        NSNumber *setupDone = [[NSUserDefaults standardUserDefaults]objectForKey:STATIC_USERDEFAULTS_SETUPDONE];
        if ([setupDone boolValue]){
            vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
        }else{
            vc = [self.storyboard instantiateViewControllerWithIdentifier:STATIC_IDENTIFIER_SETUPSTART];
        }
    }else{
        vc = [self.storyboard instantiateViewControllerWithIdentifier:STATIC_IDENTIFIER_SETUPSTART];
    }
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
