//
//  AppDelegate.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 2/28/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:STATIC_USERDEFAULTS_TRADEHISTORY]){
        [userDefaults setObject:[NSArray new] forKey:STATIC_USERDEFAULTS_TRADEHISTORY];
        [userDefaults synchronize];
    }
    
    if (![userDefaults objectForKey:STATIC_USERDEFAULTS_MYCURRENCY]){
        [userDefaults setObject:[NSDictionary new] forKey:STATIC_USERDEFAULTS_MYCURRENCY];
        [userDefaults synchronize];
    }
    
    [self initSetup];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Custom setup

- (void)initSetup{
    [[UITabBar appearance] setBarTintColor:AppStyle.primaryLightColor]; //background
    [[UITabBar appearance] setTintColor:AppStyle.primaryColor]; //selected image
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : AppStyle.primaryColor }
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : AppStyle.primaryTextColor }
                                             forState:UIControlStateNormal];
    
    if (@available(iOS 11.0, *)) {
        if ([UIButton respondsToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)]) {
            [[UIButton appearanceWhenContainedInInstancesOfClasses:@[UINavigationBar.class]]setTintColor:AppStyle.primaryTextColor];
        }
    }else{
        [[UINavigationBar appearance]setTintColor:AppStyle.primaryTextColor];
    }
    
    [[UINavigationBar appearance]setBarTintColor:AppStyle.primaryDarkColor];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : AppStyle.primaryTextColor}];
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"General_search", nil) attributes:@{NSForegroundColorAttributeName: AppStyle.primaryTextColor}]];
//    UIImage *image = [[[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithColor:[UIColor searchTintColor]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [[UISearchBar appearance] setImage:image forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"clearSearchText"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:AppStyle.primaryTextColor]; //CURSOR color without changing CANCEL color
    [[UISearchBar appearance] setTintColor:AppStyle.primaryTextColor]; //cancel button
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSForegroundColorAttributeName: AppStyle.primaryTextColor}]; //search bar set text color
    
    [[UISwitch appearance] setOnTintColor:AppStyle.primaryDarkColor];
    [[UISwitch appearance] setTintColor:AppStyle.primaryColor];
    [[UISwitch appearance] setThumbTintColor:AppStyle.primaryColor];
    
    [[UIButton appearance]setTintColor:AppStyle.primaryTextColor];
//    [[UIButton appearance]setTitleColor:[UIColor buttonDisabledColor] forState:UIControlStateDisabled];
    [[UITableView appearance]setSeparatorColor:AppStyle.primaryColor];
//    [[UIRefreshControl appearance]setBackgroundColor:[UIColor viewBackgroundColor]];
    [[UIRefreshControl appearance]setTintColor:AppStyle.primaryColor];
    [[UISlider appearance]setThumbTintColor:AppStyle.primaryColor];
    [[UISlider appearance]setTintColor:AppStyle.primaryColor];
    
    [[UISegmentedControl appearance]setTintColor:AppStyle.primaryDarkColor];
    
//    [[UIActivityIndicatorView appearance]setColor:[UIColor activityIndicatorTintColor]];
}


@end
