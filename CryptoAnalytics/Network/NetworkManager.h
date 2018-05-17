//
//  NetworkManager.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject<NSURLSessionDelegate>

+ (id)sharedManager;

//- (void)loginWithUsername:(NSString *)username password:(NSString *)password testUsername:(NSString *)testUsername withCompletionHandler:(void (^)(bool successful, NSError *httpError))completionHandler;

- (void)getHomeWithCompletionHandler:(void (^)(bool successful, NSError *httpError))completionHandler;
- (void)getCurrenciesWithCompletionHandler:(void (^)(bool successful, NSArray *currencies, NSError *httpError))completionHandler;
- (void)getConfigWithCompletionHandler:(void (^)(bool successful, NSDictionary *config, NSError *httpError))completionHandler;
- (void)getSuggestionsWithCompletionHandler:(void (^)(bool successful, NSArray *suggestions, NSError *httpError))completionHandler;
- (void)patchConfig:(NSDictionary *)config withCompletionHandler:(void (^)(bool successful, NSDictionary *config, NSError *httpError))completionHandler;
- (void)buyCurrency:(NSString *)currency forAmount:(NSInteger)amount withCompletionHandler:(void (^)(bool successful, NSDictionary *trade, NSError *httpError))completionHandler;
- (void)sellCurrency:(NSString *)currency forAmount:(double)amount withCompletionHandler:(void (^)(bool successful, NSDictionary *trade, NSError *httpError))completionHandler;

@end
