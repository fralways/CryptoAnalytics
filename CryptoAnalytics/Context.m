//
//  Context.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "Context.h"

@implementation Context

+ (Context *)sharedContext {
    static Context *context = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[self alloc] init];
        [context initParams];
    });
    return context;
}

- (void)initParams{
    self.host = @"http://192.168.0.14:8080/crypto_war_exploded";
}

@end
