//
//  ViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 2/28/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "CurrencyViewController.h"
#import "Currency.h"
#import "CurrencyTableViewCell.h"
#import "CurrencyDetailsViewController.h"

@interface CurrencyViewController ()

@property NSMutableArray<Currency *> *currentValues;
@property NSMutableArray<Currency *> *previousValues;
@property UIRefreshControl *refreshControl;
@property BOOL refreshing;
@property NSTimer *refreshTimer;

@end

@implementation CurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Currencies";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = AppStyle.primaryLightColor;

    [self initRefreshControl];
    self.refreshing = YES;
//    [self getCurrencies];
    [self initTimer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initTimer{
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getCurrencies) userInfo:nil repeats:YES];
    [self.refreshTimer fire];
}

- (void)initRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullCurrencies) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Refresh control

- (void)pullCurrencies{
    if (!self.refreshing){
        self.refreshing = YES;
        [self.refreshControl beginRefreshing];
        [self getCurrencies];
    }
}

#pragma mark - Table view

- (void)setupCellGraphics:(CurrencyTableViewCell *)cell withValue:(Currency *)value{
    if (value.change24HourPct > 0){
        cell.lblPrice.textColor = AppStyle.primaryIncreaseColor;
    }else if (value.change24HourPct < 0){
        cell.lblPrice.textColor = AppStyle.primaryDecreaseColor;
    }else{
        cell.lblPrice.textColor = AppStyle.primaryTextColor;
    }
    cell.lblPrice.font = [UIFont systemFontOfSize:AppStyle.cellDetailsFontSize];
    cell.lblName.font = [UIFont systemFontOfSize:AppStyle.cellFontSize];
    cell.lblName.textColor = AppStyle.primaryTextColor;
    
    UIView *selection = [[UIView alloc]init];
    selection.backgroundColor = AppStyle.primaryColor;
    cell.selectedBackgroundView = selection;
    cell.backgroundColor = AppStyle.primaryLightColor;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.currentValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_CURRENCY];
    
    Currency *currentValue = self.currentValues[indexPath.row];
    Currency *previousValue = nil;
    if (self.previousValues != nil && self.previousValues[indexPath.row] != nil){
        previousValue = self.previousValues[indexPath.row];
    }
    
    cell.lblName.text = currentValue.fromSymbol;
    cell.imgCurrency.image = [UIImage imageNamed:[currentValue.fromSymbol lowercaseString]];

    NSString *text = [NSString stringWithFormat:@"$ %.8g", currentValue.price];
    cell.lblPrice.text = text;

    [self setupCellGraphics:cell withValue:currentValue];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:STATIC_SEGUE_CURRENCYDETAIL sender:self.currentValues[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Network

- (void)getCurrencies{
    self.previousValues = self.currentValues;
    
    if (![Context sharedContext].testing){
        [[NetworkManager sharedManager] getCurrenciesWithCompletionHandler:^(bool successful, NSArray *currencies, NSError *httpError) {
            if (successful){
                NSMutableArray<Currency *> *convertedCurrencies = [NSMutableArray new];
                for (NSDictionary *currency in currencies) {
                    [convertedCurrencies addObject:[[Currency alloc]initWithCurrencyDictionary:currency]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.currentValues = convertedCurrencies;
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter]postNotificationName:STATIC_NOT_FETCHCURRENCIES object:self.currentValues];
                });
            }else{
                //error
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                self.refreshing = NO;
            });
        }];
    }else{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"currencies" ofType:@"json"];
        NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]];
        NSArray *currencies = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Currency: %@", currencies);
        NSMutableArray<Currency *> *convertedCurrencies = [NSMutableArray new];
        for (NSDictionary *currency in currencies) {
            [convertedCurrencies addObject:[[Currency alloc]initWithCurrencyDictionary:currency]];
        }
        self.refreshing = NO;
        [self.refreshControl endRefreshing];
        self.currentValues = convertedCurrencies;
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:STATIC_NOT_FETCHCURRENCIES object:self.currentValues];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:STATIC_SEGUE_CURRENCYDETAIL]){
        CurrencyDetailsViewController *vc = segue.destinationViewController;
        vc.currency = sender;
    }
}

@end
