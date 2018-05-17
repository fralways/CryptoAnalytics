//
//  Keys.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

//cells
static NSString *STATIC_CELL_CURRENCY = @"currencyCell";
static NSString *STATIC_CELL_CURRENCYDETAILS = @"CurrencyDetailsCell";
static NSString *STATIC_CELL_CURRENCYDETAILSCHART = @"CurrencyDetailsShowChartCell";
static NSString *STATIC_CELL_HISTORY = @"HistoryCell";
static NSString *STATIC_CELL_SETTINGSSLIDER = @"SettingsSliderCell";
static NSString *STATIC_CELL_SETTINGSSUBTITLE = @"SettingsSubtitleCell";
static NSString *STATIC_CELL_SETTINGSPICKER = @"SettingsPickerCell";
static NSString *STATIC_CELL_ANALYZER = @"AnalyzerCell";


//segues
static NSString *STATIC_SEGUE_CURRENCYDETAIL = @"CurrencyDetailSegue";
static NSString *STATIC_SEGUE_CURRENCYDETAILCHART = @"CurrencyChartSegue";

//notifications
static NSString *STATIC_NOT_BUYCURRENCY = @"CurrencyBoughtNotification";
static NSString *STATIC_NOT_SELLCURRENCY = @"CurrencySoldNotification";


//other
static NSString *STATIC_USERDEFAULTS_TRADEHISTORY = @"CryptoAnalyticsUserDefaultsTradeHistory";
static NSString *STATIC_USERDEFAULTS_MYCURRENCY = @"CryptoAnalyticsUserDefaultsMyCurrency";

@interface Keys : NSObject

@end
