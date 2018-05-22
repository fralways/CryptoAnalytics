//
//  NSDate+AnalyzerDate.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/14/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSDateFormatter *formatter;
static NSDateFormatter *historyFormatter;

@interface NSDate (AnalyzerDate)

+ (NSDate *)dateFromTimestamp:(long)timestamp;
+ (NSString *)historyStringFromDate:(NSDate *)date;
+ (NSString *)stringFromTimestamp:(long)timestamp;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
