//
//  Context.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetupParams.h"
#import "Enums.h"

@interface Context : NSObject

+ (Context *)sharedContext;

@property NSString *host;
@property BOOL testing;
@property NSMutableDictionary *myCurrencies;
@property SetupParams *setupParams;
@property BOOL didSetup;

- (NSString *)strategyToString:(STRATEGIES)strategy;
- (void)addCurrency:(NSString *)currency amount:(double)amount;

@end
