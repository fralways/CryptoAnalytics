//
//  NSDate+AnalyzerDate.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/14/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "NSDate+AnalyzerDate.h"

@implementation NSDate (AnalyzerDate)

+ (NSDate *)dateFromTimestamp:(long)timestamp{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:timestamp/1000];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    if (formatter == NULL){
        formatter = [NSDateFormatter new];
        //        [formatter setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    
    return [formatter stringFromDate:date];
}

+ (NSString *)historyStringFromDate:(NSDate *)date{
    if (historyFormatter == NULL){
        historyFormatter = [NSDateFormatter new];
        [historyFormatter setDateFormat:@"dd. MMMM HH:mm"];
    }
    
    return [historyFormatter stringFromDate:date];
}

+ (NSString *)stringFromTimestamp:(long)timestamp{
    NSDate *date = [NSDate dateFromTimestamp:timestamp];
    return [NSDate stringFromDate:date];
}

@end
