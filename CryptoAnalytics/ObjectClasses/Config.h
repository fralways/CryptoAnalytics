//
//  Config.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/10/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

@property NSInteger emaLongCount;
@property NSInteger emaShortCount;
@property NSInteger emaStrategyInterval;
@property NSInteger macdLongCount;
@property NSInteger macdShortCount;
@property NSInteger macdSignalCount;
@property NSInteger macdStrategyInterval;
@property NSInteger smaLongCount;
@property NSInteger smaShortCount;
@property NSInteger smaStrategyInterval;
@property NSInteger speedStrategyInterval;
@property double speedStrategyPercentChangeNeeded;
@property STRATEGIES selectedStrategy;
@property BOOL setupIsOn;

- (id)initWithNetworkData:(NSDictionary *)data;
- (NSDictionary *)toDictionary;

@end
