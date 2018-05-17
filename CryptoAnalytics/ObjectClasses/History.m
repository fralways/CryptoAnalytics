//
//  History.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/17/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "History.h"

@implementation History

- (id)initWithTradeDictionary:(NSDictionary *)trade{
    if ( self = [super init] ) {
        if ([trade objectForKey:@"currencyId"]){
            self.currencyId = [trade objectForKey:@"currencyId"];
        }
        if ([trade objectForKey:@"price"]){
            self.price = [[trade objectForKey:@"price"] doubleValue];
        }
        if ([trade objectForKey:@"amount"]){
            self.amount = [[trade objectForKey:@"amount"] doubleValue];
        }
        if ([trade objectForKey:@"tradeType"]){
            NSString *tradeType = [trade objectForKey:@"tradeType"];
            self.type = [self stringToTradeType:tradeType];
        }
        if ([trade objectForKey:@"time"]){
            self.time = [trade objectForKey:@"time"];
        }else{
            self.time = [NSDate new];
        }
    }
    return self;
}

- (NSDictionary *)toTradeDictionary{
    NSMutableDictionary *trade = [NSMutableDictionary new];
    trade[@"time"] = self.time;
    trade[@"amount"] = [NSNumber numberWithDouble:self.amount];
    trade[@"price"] = [NSNumber numberWithDouble:self.price];
    trade[@"currencyId"] = self.currencyId;
    trade[@"tradeType"] = self.type == TRADEBUY ? @"BUY" : @"SELL";
    return trade;
}

- (TradeType)stringToTradeType:(NSString *)type{
    TradeType returnType = TRADEBUY;
    if ([type isEqualToString:@"BUY"]){
        returnType = TRADEBUY;
    }else if ([type isEqualToString:@"SELL"]){
        returnType = TRADESELL;
    }else{
        NSLog(@"History: trade type not found for string: %@", type);
    }
    return returnType;
}

@end
