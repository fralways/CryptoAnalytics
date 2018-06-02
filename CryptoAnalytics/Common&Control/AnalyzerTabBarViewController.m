//
//  AnalyzerTabBarViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/29/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "AnalyzerTabBarViewController.h"
#import "UIImage+AnalyzerImage.h"

@interface AnalyzerTabBarViewController ()

@end

@implementation AnalyzerTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int i = 0;
    
    UIImage *image = nil;
    UIImage *imageSelected = nil;
    
    //unfortunately cannot set tint color of unselected tab
    //maybe is fixed in ios10? self.tabBar.unselectedItemTintColor = unselectedcolor
    for(UITabBarItem *item in self.tabBar.items) {
        switch (i) {
            case 0:
                image = [[[[UIImage imageNamed:@"market"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithColor:AppStyle.primaryTextColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSelected = [UIImage imageNamed:@"market"];
                break;
            case 1:
                image = [[[[UIImage imageNamed:@"analyze"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithColor:AppStyle.primaryTextColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSelected = [UIImage imageNamed:@"analyze"];
                break;
            case 2:
                image = [[[[UIImage imageNamed:@"history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithColor:AppStyle.primaryTextColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSelected = [UIImage imageNamed:@"history"];
                break;
            case 3:
                image = [[[[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithColor:AppStyle.primaryTextColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSelected = [UIImage imageNamed:@"settings"];
                break;
            default:
                break;
        }
        
        item.image = image;
        item.selectedImage = imageSelected;
        
        i++;
    }
    
//    [[self.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"Timeline_title", nil)];
//    [[self.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"Todo_title", nil)];
//    [[self.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"Mainsettings_title", nil)];
//    [[self.tabBar.items objectAtIndex:3] setTitle:NSLocalizedString(@"Tenant_title", nil)];
//    [[self.tabBar.items objectAtIndex:4] setTitle:NSLocalizedString(@"RecentRequests_title", nil)];
    
    //preload vcs
    UINavigationController *historyViewControllerNavigation = self.viewControllers[2];
    [[historyViewControllerNavigation.viewControllers objectAtIndex:0] view];
    UINavigationController *currencyViewControllerNavigation = self.viewControllers[0];
    [[currencyViewControllerNavigation.viewControllers objectAtIndex:0] view];

    self.selectedIndex = 1;
    
    NSLog(@"Tabbar: loaded");
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
