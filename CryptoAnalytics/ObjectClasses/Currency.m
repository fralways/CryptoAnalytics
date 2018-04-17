//
//  Currency.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/6/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "Currency.h"

@implementation Currency

- (id)initWithCurrencyDictionary:(NSDictionary *)currency{
    if ( self = [super init] ) {
        if ([currency objectForKey:@"change24Hour"]){
            self.change24hour = [[currency objectForKey:@"change24Hour"] doubleValue];
        }
        if ([currency objectForKey:@"change24HourPct"]){
            self.change24HourPct = [[currency objectForKey:@"change24HourPct"] doubleValue];
        }
        if ([currency objectForKey:@"flags"]){
            self.flags = [[currency objectForKey:@"flags"] integerValue];
        }
        if ([currency objectForKey:@"fromSymbol"]){
            self.fromSymbol = [currency objectForKey:@"fromSymbol"];
        }
        if ([currency objectForKey:@"high24Hour"]){
            self.high24Hour = [[currency objectForKey:@"high24Hour"] doubleValue];
        }
        if ([currency objectForKey:@"highHour"]){
            self.highHour = [[currency objectForKey:@"highHour"] doubleValue];
        }
        if ([currency objectForKey:@"lastMarket"]){
            self.lastMarket = [currency objectForKey:@"lastMarket"];
        }
        if ([currency objectForKey:@"lastTradeId"]){
            self.lastTradeId = [[currency objectForKey:@"lastTradeId"] doubleValue];
        }
        if ([currency objectForKey:@"lastUpdate"]){
            self.lastUpdate = [[currency objectForKey:@"lastUpdate"] doubleValue];
        }
        if ([currency objectForKey:@"lastVolume"]){
            self.lastVolume = [[currency objectForKey:@"lastVolume"] doubleValue];
        }
        if ([currency objectForKey:@"lastVolumeTo"]){
            self.lastVolumeTo = [[currency objectForKey:@"lastVolumeTo"] doubleValue];
        }
        if ([currency objectForKey:@"low24Hour"]){
            self.low24Hour = [[currency objectForKey:@"low24Hour"] doubleValue];
        }
        if ([currency objectForKey:@"lowHour"]){
            self.lowHour = [[currency objectForKey:@"lowHour"] doubleValue];
        }
        if ([currency objectForKey:@"market"]){
            self.market = [currency objectForKey:@"market"];
        }
        if ([currency objectForKey:@"open24Hour"]){
            self.open24Hour = [[currency objectForKey:@"open24Hour"] doubleValue];
        }
        if ([currency objectForKey:@"openHour"]){
            self.openHour = [[currency objectForKey:@"openHour"] doubleValue];
        }
        if ([currency objectForKey:@"price"]){
            self.price = [[currency objectForKey:@"price"] doubleValue];
        }
        if ([currency objectForKey:@"toSymbol"]){
            self.toSymbol = [currency objectForKey:@"toSymbol"];
        }
        if ([currency objectForKey:@"volume24Hour"]){
            self.volume24Hour = [[currency objectForKey:@"volume24Hour"] doubleValue];
        }
        if ([currency objectForKey:@"volume24HourTo"]){
            self.volume24HourTo = [[currency objectForKey:@"volume24HourTo"] doubleValue];
        }
        if ([currency objectForKey:@"volumeHour"]){
            self.volumeHour = [[currency objectForKey:@"volumeHour"] doubleValue];
        }
        if ([currency objectForKey:@"volumeHourTo"]){
            self.volumeHourTo = [[currency objectForKey:@"volumeHourTo"] doubleValue];
        }
    }
    return self;
}

@end
