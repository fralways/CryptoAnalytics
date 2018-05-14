//
//  Suggestion.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/14/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BUY,
    SELL
}SuggestionType;

@interface Suggestion : NSObject

- (id)initWithSuggestionDictionary:(NSDictionary *)suggestion;

@property NSString *currency;
@property STRATEGIES strategy;
@property long timestamp;
@property SuggestionType type;

@end
