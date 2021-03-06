//
//  HistoryViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 4/22/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "History.h"
#import "NSDate+AnalyzerDate.h"
#import "Currency.h"

@interface HistoryViewController ()

@property NSMutableArray<History *> *history;
@property NSDictionary<NSString *, Currency *> *currencies;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"History";
    
    [self initHistory];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupUI];
        
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(boughtCurrency:) name:STATIC_NOT_BUYCURRENCY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(soldCurrency:) name:STATIC_NOT_SELLCURRENCY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchCurrencies:) name:STATIC_NOT_FETCHCURRENCIES object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Init & UI

- (void)initHistory{
    self.history = [NSMutableArray new];
    NSArray *defaultsHistory = [[NSUserDefaults standardUserDefaults] objectForKey:STATIC_USERDEFAULTS_TRADEHISTORY];
    for (NSDictionary *historyDict in defaultsHistory) {
        History *history = [[History alloc]initWithTradeDictionary:historyDict];
        [self.history insertObject:history atIndex:0];
    }
}

- (void)setupUI{
    self.view.backgroundColor = AppStyle.primaryLightColor;
    self.lblGainText.textColor = AppStyle.primaryTextColor;
    self.lblGainAmount.textColor = AppStyle.primaryTextColor;
    self.btnFilter.layer.borderColor = [[UIColor darkTextColor] CGColor];
    self.btnFilter.layer.borderWidth = 1;
    self.btnFilter.layer.cornerRadius = 8;
    [self.btnFilter setHidden:YES];
    self.tableView.backgroundColor = AppStyle.primaryLightColor;
}

#pragma mark - Table view

- (void)setupCellGraphics:(HistoryTableViewCell *)cell{
    cell.lblCurrency.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblAmount.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblPrice.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblType.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblGain.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];

    cell.lblType.textColor = AppStyle.primaryTextColor;
    cell.lblDate.textColor = AppStyle.primaryTextColor;
    cell.lblPrice.textColor = AppStyle.primaryTextColor;
    cell.lblAmount.textColor = AppStyle.primaryTextColor;
    cell.lblCurrency.textColor = AppStyle.primaryTextColor;
    cell.lblGain.textColor = AppStyle.primaryTextColor;
    cell.backgroundColor = AppStyle.primaryLightColor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)refreshTableView{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_HISTORY];
    
    History *history = self.history[indexPath.row];
    if (history.type == TRADEBUY){
        double spentMoney = history.amount * history.price;
        cell.lblType.text = @"Type: BUY";
        cell.lblCurrency.text = [NSString stringWithFormat:@"Currency: %@", history.currencyId];
        cell.lblPrice.text = [NSString stringWithFormat:@"Price: %f", history.price];
        cell.lblAmount.text = [NSString stringWithFormat:@"Bough units: %f", history.amount];
        cell.lblGain.text = [NSString stringWithFormat:@"Spent: $%f", spentMoney];
    }else{
        double currencyAmountSold = history.amount / history.price;
        cell.lblType.text = @"Type: SELL";
        cell.lblCurrency.text = [NSString stringWithFormat:@"Currency: %@", history.currencyId];
        cell.lblPrice.text = [NSString stringWithFormat:@"Price: %f", history.price];
        cell.lblAmount.text = [NSString stringWithFormat:@"Sold units: %f", currencyAmountSold];
        cell.lblGain.text = [NSString stringWithFormat:@"Gain: $%f", history.amount];
    }
    
    cell.lblDate.text = [NSDate historyStringFromDate:history.time];
    
    [self setupCellGraphics:cell];
    
    return cell;
}

#pragma mark - Notifications

- (void)boughtCurrency:(NSNotification *)notification{
    History *history = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.history insertObject:history atIndex:0];
        [self refreshTableView];
    });
}

- (void)soldCurrency:(NSNotification *)notification{
    History *history = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.history insertObject:history atIndex:0];
        [self refreshTableView];
    });
}

- (void)fetchCurrencies:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currencies = [self currencyArrayToDictionary:notification.object];
        double gain = [self calculateGain];
        self.lblGainAmount.text = [NSString stringWithFormat:@"$%f", gain];
    });
}

#pragma mark - Helper

- (double)calculateGain{
    double gain = [[[NSUserDefaults standardUserDefaults] objectForKey:STATIC_USERDEFAULTS_MYMONEY] doubleValue];
    for (NSString *currencyId in self.currencies) {
        Currency *currency = self.currencies[currencyId];
        if ([[Context sharedContext].myCurrencies objectForKey:currencyId]){
            double amount = [[[Context sharedContext].myCurrencies objectForKey:currencyId] doubleValue];
            gain += amount * currency.price;
        }
    }
    return gain;
}

- (NSDictionary<NSString *, Currency *> *)currencyArrayToDictionary:(NSArray *)currencyArray{
    NSMutableDictionary<NSString *, Currency *> *currencyDictionary = [NSMutableDictionary new];
    for (Currency *currency in currencyArray) {
        [currencyDictionary setValue:currency forKey:currency.fromSymbol];
    }
    return currencyDictionary;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)filter:(id)sender {
}
@end
