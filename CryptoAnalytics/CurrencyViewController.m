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

@end

@implementation CurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Currencies";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self initRefreshControl];
    self.refreshing = YES;
    [self getCurrencies];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullCurrencies) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Table view

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
    if (previousValue){
        if (previousValue.price > currentValue.price){
            cell.lblPrice.textColor = [UIColor redColor];
        }else if (previousValue.price < currentValue.price){
            cell.lblPrice.textColor = [UIColor greenColor];
        }else{
            cell.lblPrice.textColor = [UIColor blackColor];
        }
    }else{
        cell.lblPrice.textColor = [UIColor blackColor];
    }
    cell.lblPrice.text = text;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:STATIC_SEGUE_CURRENCYDETAIL sender:self.currentValues[indexPath.row]];
}

#pragma mark - Network

- (void)getCurrencies{
    self.previousValues = self.currentValues;
    [[NetworkManager sharedManager] getCurrenciesWithCompletionHandler:^(bool successful, NSArray *currencies, NSError *httpError) {
        if (successful){
            NSMutableArray<Currency *> *convertedCurrencies = [NSMutableArray new];
            for (NSDictionary *currency in currencies) {
                [convertedCurrencies addObject:[[Currency alloc]initWithCurrencyDictionary:currency]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentValues = convertedCurrencies;
                [self.tableView reloadData];
            });
        }else{
            //error
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.refreshing = NO;
        });
    }];
}

- (void)pullCurrencies{
    if (!self.refreshing){
        self.refreshing = YES;
        [self.refreshControl beginRefreshing];
        [self getCurrencies];
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
