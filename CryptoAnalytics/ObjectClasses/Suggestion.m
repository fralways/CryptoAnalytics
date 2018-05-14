//
//  Suggestion.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/14/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "Suggestion.h"

@implementation Suggestion

- (id)initWithSuggestionDictionary:(NSDictionary *)suggestion{
    if ( self = [super init] ) {
        if ([suggestion objectForKey:@"timestamp"]){
            self.timestamp = [[suggestion objectForKey:@"timestamp"] longValue];

        }
        if ([suggestion objectForKey:@"symbol"]){
            self.currency = [suggestion objectForKey:@"symbol"];
        }
        if ([suggestion objectForKey:@"strategy"]){
            NSString *strategyString = [suggestion objectForKey:@"strategy"];
            if ([strategyString isEqualToString:@"SPEED"]){
                self.strategy = SPEED;
            }else if ([strategyString isEqualToString:@"MACD"]){
                self.strategy = MACD;
            }else if ([strategyString isEqualToString:@"EMA"]){
                self.strategy = EMA;
            }else if ([strategyString isEqualToString:@"SMA"]){
                self.strategy = SMA;
            }else{
                NSLog(@"Suggestion: strategy not found for string: %@", strategyString);
            }
        }
        if ([suggestion objectForKey:@"suggestionType"]){
            NSString *typeString = [suggestion objectForKey:@"suggestionType"];
            if ([typeString isEqualToString:@"BUY"]){
                self.type = BUY;
            }else if ([typeString isEqualToString:@"SELL"]){
                self.type = SELL;
            }else{
                NSLog(@"Suggestion: suggestion type not found for string: %@", typeString);
            }
        }

    }
    return self;
}

@end
