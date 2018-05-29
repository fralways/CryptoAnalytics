//
//  Context.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: NSInteger{
    SPEED   = 0,
    MACD,
    EMA,
    SMA
}STRATEGIES;

@interface Context : NSObject

+ (Context *)sharedContext;

@property NSString *host;
@property BOOL testing;
@property NSMutableDictionary *myCurrencies;

- (NSString *)strategyToString:(STRATEGIES)strategy;
- (void)addCurrency:(NSString *)currency amount:(double)amount;

@end
