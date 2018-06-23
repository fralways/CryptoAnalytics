//
//  Config.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/10/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "Config.h"

@implementation Config

- (id)initWithNetworkData:(NSDictionary *)data{
    self = [super init];
    if(self) {
        NSLog(@"Config: init with data: %@", data);

        if ([data objectForKey:@"emaLongCount"]){
            self.emaLongCount = [[data objectForKey:@"emaLongCount"] integerValue];
        }
        if ([data objectForKey:@"emaShortCount"]){
            self.emaShortCount = [[data objectForKey:@"emaShortCount"] integerValue];
        }
        if ([data objectForKey:@"emaStrategyInterval"]){
            self.emaStrategyInterval = [[data objectForKey:@"emaStrategyInterval"] integerValue];
        }
        if ([data objectForKey:@"macdLongCount"]){
            self.macdLongCount = [[data objectForKey:@"macdLongCount"] integerValue];
        }
        if ([data objectForKey:@"macdShortCount"]){
            self.macdShortCount = [[data objectForKey:@"macdShortCount"] integerValue];
        }
        if ([data objectForKey:@"macdSignalCount"]){
            self.macdSignalCount = [[data objectForKey:@"macdSignalCount"] integerValue];
        }
        if ([data objectForKey:@"macdStrategyInterval"]){
            self.macdStrategyInterval = [[data objectForKey:@"macdStrategyInterval"] integerValue];
        }
        if ([data objectForKey:@"smaLongCount"]){
            self.smaLongCount = [[data objectForKey:@"smaLongCount"] integerValue];
        }
        if ([data objectForKey:@"smaShortCount"]){
            self.smaShortCount = [[data objectForKey:@"smaShortCount"] integerValue];
        }
        if ([data objectForKey:@"smaStrategyInterval"]){
            self.smaStrategyInterval = [[data objectForKey:@"smaStrategyInterval"] integerValue];
        }
        if ([data objectForKey:@"speedStrategyInterval"]){
            self.speedStrategyInterval = [[data objectForKey:@"speedStrategyInterval"] integerValue];
        }
        if ([data objectForKey:@"speedStrategyPercentChangeNeeded"]){
            self.speedStrategyPercentChangeNeeded = [[data objectForKey:@"speedStrategyPercentChangeNeeded"] doubleValue];
        }
        if ([data objectForKey:@"selectedStrategy"]){
            NSString *strategyString = [data objectForKey:@"selectedStrategy"];
            if ([strategyString isEqualToString:@"SPEED"]){
                self.selectedStrategy = SPEED;
            }else if ([strategyString isEqualToString:@"MACD"]){
                self.selectedStrategy = MACD;
            }else if ([strategyString isEqualToString:@"EMA"]){
                self.selectedStrategy = EMA;
            }else if ([strategyString isEqualToString:@"SMA"]){
                self.selectedStrategy = SMA;
            }else{
                NSLog(@"Config: strategy not found for string: %@", strategyString);
            }
        }
    }
    return self;
}

- (NSDictionary *)toDictionary{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if (self.setupIsOn){
        dictionary[@"selectedStrategy"] = [[Context sharedContext] strategyToString:self.selectedStrategy];
    }else{
        dictionary[@"selectedStrategy"] = [[Context sharedContext] strategyToString:self.selectedStrategy];
        dictionary[@"speedStrategyPercentChangeNeeded"] = [NSNumber numberWithDouble:self.speedStrategyPercentChangeNeeded];
        dictionary[@"speedStrategyInterval"] = [NSNumber numberWithInteger:self.speedStrategyInterval];
        dictionary[@"smaStrategyInterval"] = [NSNumber numberWithInteger:self.smaStrategyInterval];
        dictionary[@"smaStrategyShortCount"] = [NSNumber numberWithInteger:self.smaShortCount];
        dictionary[@"smaStrategyLongCount"] = [NSNumber numberWithInteger:self.smaLongCount];
        dictionary[@"emaStrategyInterval"] = [NSNumber numberWithInteger:self.emaStrategyInterval];
        dictionary[@"emaStrategyShortCount"] = [NSNumber numberWithInteger:self.emaShortCount];
        dictionary[@"emaStrategyLongCount"] = [NSNumber numberWithInteger:self.emaLongCount];
        dictionary[@"macdStrategyShortCount"] = [NSNumber numberWithInteger:self.macdShortCount];
        dictionary[@"macdStrategyLongCount"] = [NSNumber numberWithInteger:self.macdLongCount];
        dictionary[@"macdStrategySignalCount"] = [NSNumber numberWithInteger:self.macdSignalCount];
        dictionary[@"macdStrategyInterval"] = [NSNumber numberWithInteger:self.macdStrategyInterval];
    }
    return dictionary;
}

@end
