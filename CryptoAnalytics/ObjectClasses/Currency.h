//
//  Currency.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/6/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

-(id)initWithCurrencyDictionary:(NSDictionary *)currency;

@property double change24hour;
@property double change24HourPct;
@property NSInteger flags;
@property NSString *fromSymbol;
@property double high24Hour;
@property double highHour;
@property NSString *lastMarket;
@property double lastTradeId;
@property double lastUpdate;
@property double lastVolume;
@property double lastVolumeTo;
@property double low24Hour;
@property double lowHour;
@property NSString *market;
@property double open24Hour;
@property double openHour;
@property double price;
@property NSString *toSymbol;
@property double volume24Hour;
@property double volume24HourTo;
@property double volumeHour;
@property double volumeHourTo;

@end
