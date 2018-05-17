//
//  History.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/17/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TRADEBUY,
    TRADESELL
}TradeType;

@interface History : NSObject

@property NSDate *time;
@property double amount;
@property double price;
@property NSString *currencyId;
@property TradeType type;

- (id)initWithTradeDictionary:(NSDictionary *)trade;
- (NSDictionary *)toTradeDictionary;

@end
