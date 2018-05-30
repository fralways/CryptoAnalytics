//
//  AnalyzerViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/27/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "AnalyzerViewController.h"
#import "Suggestion.h"
#import "NSDate+AnalyzerDate.h"
#import "SCLAlertView.h"
#import "History.h"

@interface AnalyzerViewController ()

@property NSArray *suggestionsArray;
@property NSMutableArray<Suggestion *> *suggestions;
@property UIRefreshControl *refreshControl;
@property BOOL loading;
@property NSUserDefaults *userDefaults;

//alert
@property UILabel *lblSlider;
@property Suggestion *suggestionClicked;

@end

@implementation AnalyzerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Suggestions";
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = AppStyle.primaryLightColor;
    
    [self initRefreshControl];
    [self getSuggestions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initRefreshControl{
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(getSuggestions) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
}

#pragma mark - Network

- (void)buyCurrency:(NSString *)currency forAmount:(NSInteger)amount{
    [[NetworkManager sharedManager]buyCurrency:currency forAmount:amount withCompletionHandler:^(bool successful, NSDictionary *trade, NSError *httpError) {
        if (successful){
            dispatch_async(dispatch_get_main_queue(), ^{
                History *history = [[History alloc]initWithTradeDictionary:trade];
                NSMutableArray *tradeDefaults = [[self.userDefaults objectForKey:STATIC_USERDEFAULTS_TRADEHISTORY] mutableCopy];
                [tradeDefaults addObject:[history toTradeDictionary]];
                [self.userDefaults setObject:tradeDefaults forKey:STATIC_USERDEFAULTS_TRADEHISTORY];
                [self.userDefaults synchronize];
                
                [[Context sharedContext]addCurrency:currency amount:history.amount/history.price];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:STATIC_NOT_BUYCURRENCY object:history];
                [self presentAlertBuySuccess:history.amount];
            });
            
        }
    }];
}

- (void)sellCurrency:(NSString *)currency forAmount:(double)amount{
    [[NetworkManager sharedManager]sellCurrency:currency forAmount:amount withCompletionHandler:^(bool successful, NSDictionary *trade, NSError *httpError) {
        if (successful){
            dispatch_async(dispatch_get_main_queue(), ^{
                History *history = [[History alloc]initWithTradeDictionary:trade];
                NSMutableArray *tradeDefaults = [[self.userDefaults objectForKey:STATIC_USERDEFAULTS_TRADEHISTORY] mutableCopy];
                [tradeDefaults addObject:[history toTradeDictionary]];
                [self.userDefaults setObject:tradeDefaults forKey:STATIC_USERDEFAULTS_TRADEHISTORY];
                [self.userDefaults synchronize];
                
                [[Context sharedContext]addCurrency:currency amount:-amount];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:STATIC_NOT_SELLCURRENCY object:history];
                [self presentAlertSellSuccess:history.amount];
            });
        }
    }];
}

- (void)getSuggestions{
    if (!self.loading){
        self.loading = YES;
        
        if (![Context sharedContext].testing){
            [[NetworkManager sharedManager]getSuggestionsWithCompletionHandler:^(bool successful, NSArray *suggestions, NSError *httpError) {
                if (successful){
                    NSLog(@"Analyzer: got suggestions: %@", suggestions);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.loading = NO;
                        self.suggestionsArray = suggestions;
                        self.suggestions = [NSMutableArray new];
                        for (NSDictionary *suggestionDictionary in suggestions) {
                            Suggestion *suggestion = [[Suggestion alloc]initWithSuggestionDictionary:suggestionDictionary];
                            [self.suggestions addObject:suggestion];
                        }
                        [self refreshTable];
                        [self.refreshControl endRefreshing];
                    });
                }
            }];
        }else{
            NSString *path = [[NSBundle mainBundle]pathForResource:@"suggestions" ofType:@"json"];
            NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]];
            NSArray *suggestions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Analyzer: %@", suggestions);
            self.loading = NO;
            self.suggestionsArray = suggestions;
            self.suggestions = [NSMutableArray new];
            for (NSDictionary *suggestionDictionary in suggestions) {
                Suggestion *suggestion = [[Suggestion alloc]initWithSuggestionDictionary:suggestionDictionary];
                [self.suggestions addObject:suggestion];
            }
            [self refreshTable];
            [self.refreshControl endRefreshing];
        }
    }else{
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Table

- (void)setCellGraphics:(AnalyzerTableViewCell *)cell withSuggestionType: (SuggestionType)type{
    [cell.btnAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (type == BUY){
        [cell.btnAction setTitle:@"BUY" forState:UIControlStateNormal];
        [cell.btnAction setBackgroundColor:AppStyle.primaryIncreaseColor];
    }else{
        [cell.btnAction setTitle:@"SELL" forState:UIControlStateNormal];
        [cell.btnAction setBackgroundColor:AppStyle.primaryDecreaseColor];
    }
    
    cell.btnAction.layer.cornerRadius = 3.0;
    
    cell.lblText.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblCurrency.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblTimestamp.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.btnAction.titleLabel.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblText.textColor = AppStyle.primaryTextColor;
    cell.lblCurrency.textColor = AppStyle.primaryTextColor;
    cell.lblTimestamp.textColor = AppStyle.primaryTextColor;
    cell.backgroundColor = AppStyle.primaryLightColor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)refreshTable{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.suggestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnalyzerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_ANALYZER];
    
    Suggestion *suggestion = self.suggestions[indexPath.row];
    
    cell.delegate = self;
    cell.lblCurrency.text = [NSString stringWithFormat:@"Currency: %@", suggestion.currency];
    cell.lblTimestamp.text = [NSString stringWithFormat:@"Suggestion time: %@", [NSDate stringFromTimestamp:suggestion.timestamp]];
    cell.lblText.text = [NSString stringWithFormat:@"Strategy: %@", [[Context sharedContext]strategyToString:suggestion.strategy]];
    [self setCellGraphics:cell withSuggestionType:suggestion.type];
    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark - Delegates

- (void)actionClickedWithTag:(NSInteger)tag{
    Suggestion *suggestion = self.suggestions[tag];
    self.suggestionClicked = suggestion;
    
    if (suggestion.type == BUY){
        [self presentAlertBuy];
    }else{
        [self presentAlertSell];
    }
}

#pragma mark - Alerts

- (void)sliderValueChanged:(UISlider *)slider{
    int amount = (int)slider.value;
    self.lblSlider.text = [NSString stringWithFormat:@"%d$", amount];
}

- (void)sliderDoubleValueChanged:(UISlider *)slider{
    double amount = slider.value;
    self.lblSlider.text = [NSString stringWithFormat:@"%.6f", amount];
}

- (void)presentAlertBuy{
    
    UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 215, 30)];
    
    UISlider *slider = [UISlider new];
    slider.minimumValue = 10.0;
    slider.maximumValue = 100.0;
    slider.value = 20.0;
    slider.frame = CGRectMake(0, 0, 215 - 50, 30);
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(215 - 50, 0, 50, 30)];
    amount.text = @"20$";
    amount.textAlignment = NSTextAlignmentRight;
    amount.textColor = AppStyle.primaryTextColor;
    self.lblSlider = amount;
    
    [holder addSubview:slider];
    [holder addSubview:amount];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 240 - 24, 50)];
    title.textColor = AppStyle.primaryTextColor;
    title.font = [UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeBottom;
    title.text = [NSString stringWithFormat:@"Buy %@", self.suggestionClicked.currency];
    
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 240 - 24, 15)];
    title.contentMode = UIViewContentModeTop;
    subtitle.textColor = AppStyle.primaryTextColor;
    subtitle.font = [UIFont systemFontOfSize:14];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.text = @"Select amount to buy";
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .customViewColor(AppStyle.primaryColor)
    .backgroundViewColor(AppStyle.primaryLightColor)
    .shouldDismissOnTapOutside(YES)
    .addCustomView(title)
    .addCustomView(subtitle)
    .addCustomView(holder)
    .addButtonWithActionBlock(@"Confirm", ^{
        NSInteger amount = (int)slider.value;
        [self buyCurrency:self.suggestionClicked.currency forAmount:amount];
    });
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleInfo)
//    .subTitle(@"Select amount to buy")
    .closeButtonTitle(@"Cancel")
    .duration(0);
    [showBuilder showAlertView:builder.alertView onViewController:self];
}

- (void)presentAlertSell{
    
    NSNumber *myAmount = @(0);
    if ([Context sharedContext].myCurrencies[self.suggestionClicked.currency]){
        myAmount = [Context sharedContext].myCurrencies[self.suggestionClicked.currency];
    }
    
    UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 215, 30)];
    UISlider *slider = [UISlider new];
    slider.minimumValue = 0.0;
    slider.maximumValue = [myAmount doubleValue];
    slider.value = 0.0;
    slider.frame = CGRectMake(0, 0, 215 - 80, 30);
    [slider addTarget:self action:@selector(sliderDoubleValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(215 - 80, 0, 80, 30)];
    amount.text = @"0";
    amount.textAlignment = NSTextAlignmentRight;
    amount.font = [UIFont systemFontOfSize:12];
    self.lblSlider = amount;
    
    [holder addSubview:slider];
    [holder addSubview:amount];
    
    UILabel *myAmountLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 215, 20)];
    myAmountLbl.text = [NSString stringWithFormat:@"You own: %@", [myAmount stringValue]];
    myAmountLbl.textAlignment = NSTextAlignmentCenter;
    myAmountLbl.font = [UIFont systemFontOfSize:14];
    myAmountLbl.textColor = AppStyle.primaryTextColor;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 240 - 24, 50)];
    title.textColor = AppStyle.primaryTextColor;
    title.font = [UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeBottom;
    title.text = [NSString stringWithFormat:@"Sell %@", self.suggestionClicked.currency];
    
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 240 - 24, 15)];
    title.contentMode = UIViewContentModeTop;
    subtitle.textColor = AppStyle.primaryTextColor;
    subtitle.font = [UIFont systemFontOfSize:14];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.text = @"Select amount to sell";
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .customViewColor(AppStyle.primaryColor)
    .backgroundViewColor(AppStyle.primaryLightColor)
    .shouldDismissOnTapOutside(YES)
    .addCustomView(title)
    .addCustomView(subtitle)
    .addCustomView(myAmountLbl)
    .addCustomView(holder)
    .addButtonWithActionBlock(@"Confirm", ^{
        double amount = slider.value;
        [self sellCurrency:self.suggestionClicked.currency forAmount:amount];
    });
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleInfo)
    .closeButtonTitle(@"Cancel")
    .duration(0);
    [showBuilder showAlertView:builder.alertView onViewController:self];
}

- (void)presentAlertBuySuccess:(double)amount{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 240 - 24, 50)];
    title.textColor = AppStyle.primaryTextColor;
    title.font = [UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeBottom;
    title.text = [NSString stringWithFormat:@"Success"];
    
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 240 - 24, 50)];
    subtitle.textColor = AppStyle.primaryTextColor;
    subtitle.font = [UIFont systemFontOfSize:14];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.text = [NSString stringWithFormat:@"You have successfully bought %f %@", amount, self.suggestionClicked.currency];
    subtitle.numberOfLines = 2;
    subtitle.lineBreakMode = NSLineBreakByWordWrapping;

    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .shouldDismissOnTapOutside(YES)
    .customViewColor(AppStyle.primaryColor)
    .backgroundViewColor(AppStyle.primaryLightColor)
    .addCustomView(title)
    .addCustomView(subtitle);
    
    
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleSuccess)
    .closeButtonTitle(@"Ok")
    .duration(0);
    [showBuilder showAlertView:builder.alertView onViewController:self];
}

- (void)presentAlertSellSuccess:(double)amount{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 240 - 24, 50)];
    title.textColor = AppStyle.primaryTextColor;
    title.font = [UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.contentMode = UIViewContentModeBottom;
    title.text = [NSString stringWithFormat:@"Success"];
    
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 240 - 24, 50)];
    subtitle.textColor = AppStyle.primaryTextColor;
    subtitle.font = [UIFont systemFontOfSize:14];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.text = [NSString stringWithFormat:@"You have successfully sold %@ for %f$", self.suggestionClicked.currency, amount];
    subtitle.numberOfLines = 2;
    subtitle.lineBreakMode = NSLineBreakByWordWrapping;
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new]
    .shouldDismissOnTapOutside(YES)
    .customViewColor(AppStyle.primaryColor)
    .backgroundViewColor(AppStyle.primaryLightColor)
    .addCustomView(title)
    .addCustomView(subtitle);
    
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleSuccess)
    .closeButtonTitle(@"Ok")
    .duration(0);
    [showBuilder showAlertView:builder.alertView onViewController:self];
}


@end
