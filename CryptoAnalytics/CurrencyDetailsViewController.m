//
//  CurrencyDetailsViewController.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/27/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "CurrencyDetailsViewController.h"
#import "CurrencyDetailsTableViewCell.h"
//#import "CurrencyChart.swift"
#import "CryptoAnalytics-Swift.h"

typedef enum CurrencyDetails: NSInteger {
    
    DETAILSPRICE,
    DETAILSVOLUME24,
    DETAILSHIGH24,
    DETAILSLOW24,
    DETAILSSTART24,
    DETAILSCHANGE24,
    DETAILSEND

}CurrencyDetails;

//@property double change24hour;
//@property double change24HourPct;
//@property NSInteger flags;
//@property NSString *fromSymbol;
//@property double high24Hour;
//@property double highHour;
//@property NSString *lastMarket;
//@property double lastTradeId;
//@property double lastUpdate;
//@property double lastVolume;
//@property double lastVolumeTo;
//@property double low24Hour;
//@property double lowHour;
//@property NSString *market;
//@property double open24Hour;
//@property double openHour;
//@property double price;
//@property NSString *toSymbol;
//@property double volume24Hour;
//@property double volume24HourTo;
//@property double volumeHour;
//@property double volumeHourTo;

@interface CurrencyDetailsViewController ()

@end

@implementation CurrencyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTitle];
    [self setupChart];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)setupTitle{
    
    UIStackView *stackView = [UIStackView new];
    self.navigationItem.titleView = stackView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.currency.fromSymbol lowercaseString]]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *image = [self imageWithImage:[UIImage imageNamed:[self.currency.fromSymbol lowercaseString]] convertToSize:CGSizeMake(40, 40)];
    [imageView setImage:image];

    UILabel *label = [UILabel new];
    label.text = self.currency.fromSymbol;
    [label setTextAlignment:NSTextAlignmentLeft];
    
    [stackView setSpacing:4.0];
    [stackView setDistribution:UIStackViewDistributionFillEqually];
    [stackView setAlignment:UIStackViewAlignmentCenter];
    [stackView addArrangedSubview:imageView];
    [stackView addArrangedSubview:label];
}

- (void)setupChart{
    CurrencyChart *chart = [CurrencyChart new];
    [chart createChartWithSuperview:self.chartArea];
}

#pragma mark - Helper

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return DETAILSEND;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STATIC_CELL_CURRENCYDETAILS];
    
    NSString *text;
    NSString *details;
    switch (indexPath.row) {
        case DETAILSPRICE:
            text = @"Price";
            details = [NSString stringWithFormat:@"$ %.8g", self.currency.price];
            break;
        case DETAILSLOW24:
            text = @"Low 24h";
            details = [NSString stringWithFormat:@"$ %.8g", self.currency.low24Hour];
            break;
        case DETAILSHIGH24:
            text = @"High 24h";
            details = [NSString stringWithFormat:@"$ %.8g", self.currency.high24Hour];
            break;
        case DETAILSCHANGE24:
            text = @"Change 24h";
            details = [NSString stringWithFormat:@"$ %.8g", self.currency.change24hour];
            break;
        case DETAILSVOLUME24:
            text = @"Volume 24h";
            details = [NSString stringWithFormat:@"%.8g", self.currency.volume24Hour];
            break;
        case DETAILSSTART24:
            text = @"Start 24h";
            details = [NSString stringWithFormat:@"$ %.8g", self.currency.open24Hour];
            break;
        default:
            break;
    }
    
    cell.lblText.text = text;
    cell.lblDetails.text = details;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Details";
}

@end
