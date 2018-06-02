//
//  NetworkManager.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager()

@property NSURLSessionConfiguration *sessionConfiguration;
@property NSURLSession *session;
@property NSDictionary *endpoints;

@end

@implementation NetworkManager

+ (id)sharedManager {
    static NetworkManager *shareHttpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareHttpManager = [[self alloc] init];
        shareHttpManager.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        shareHttpManager.sessionConfiguration.URLCache = nil;
        shareHttpManager.sessionConfiguration.timeoutIntervalForRequest = 40.0;
        shareHttpManager.sessionConfiguration.URLCredentialStorage = nil;
        shareHttpManager.sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        shareHttpManager.session = [NSURLSession sessionWithConfiguration:shareHttpManager.sessionConfiguration
                                                                 delegate:shareHttpManager
                                                            delegateQueue:nil];
        
    });
    return shareHttpManager;
}

#pragma mark - Helper

- (NSString *)getUrlForEndpoint:(NSString *)endpoint{
    NSString *url = @"";
    if ([self.endpoints objectForKey:endpoint]){
        url = [self.endpoints objectForKey:endpoint];
        url = [[Context sharedContext].host stringByAppendingPathComponent:url];
    }
    return url;
}

#pragma mark - restful metods

- (void)get:(NSString*)absoluteURL httpAdditionalHeaders:(NSDictionary *)httpAdditionalHeaders completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler{
    
    NSURL *url = [NSURL URLWithString:absoluteURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    
    for (NSString *key in httpAdditionalHeaders) {
        [request setValue:httpAdditionalHeaders[key] forHTTPHeaderField:key];
    }
    //    [self.session setSessionDescription:absoluteURL];
    
    [[self.session dataTaskWithRequest:request completionHandler:completionHandler] resume];
}

- (void)patch:(NSString *)absoluteURL httpAdditionalHeaders: (NSDictionary*)httpAdditionalHeaders data:(id)data completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler{
    
    NSError *error;
    
    NSURL *url = [NSURL URLWithString:absoluteURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    
    for (NSString *key in httpAdditionalHeaders) {
        [request setValue:httpAdditionalHeaders[key] forHTTPHeaderField:key];
    }
    
    [request setHTTPMethod:@"PATCH"];
    
    if (data) {
        NSData *patchData = [NSJSONSerialization dataWithJSONObject:data
                                                            options:0
                                                              error:&error];
        [request setHTTPBody:patchData];
    }
    
    [[self.session dataTaskWithRequest:request completionHandler:completionHandler] resume];
}

#pragma mark - Endpoint

- (void)getHomeWithCompletionHandler:(void (^)(bool successful, NSError *httpError))completionHandler{
    NSMutableDictionary *httpAdditionalHeaders = [[NSMutableDictionary alloc] init];
    NSString *endpoint = [[Context sharedContext].host stringByAppendingPathComponent:@"home"];
    
    [self get:endpoint httpAdditionalHeaders:httpAdditionalHeaders completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (200 == httpResponse.statusCode && !error) {
                NSDictionary *homeObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                self.endpoints = homeObject[@"endpoints"];
                completionHandler(YES, nil);
            }else{
                completionHandler(NO, nil);
            }
        }else{
            completionHandler(NO, error);
        }
    }];
    
    
}

- (void)getCurrenciesWithCompletionHandler:(void (^)(bool successful, NSArray *currencies, NSError *httpError))completionHandler{
    NSMutableDictionary *httpAdditionalHeaders = [[NSMutableDictionary alloc] init];
    
    if (self.endpoints){
        NSString *endpoint = [self getUrlForEndpoint:@"currency"];
        [self get:endpoint httpAdditionalHeaders:httpAdditionalHeaders completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (200 == httpResponse.statusCode && !error) {
                    NSArray *currencies = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    completionHandler(YES, currencies, nil);
                }else{
                    completionHandler(NO, nil, nil);
                }
            }else{
                completionHandler(NO, nil, error);
            }
        }];
    }else{
        [self getHomeWithCompletionHandler:^(bool successful, NSError *httpError) {
            if (successful){
                NSString *endpoint = [self getUrlForEndpoint:@"currency"];
                [self get:endpoint httpAdditionalHeaders:httpAdditionalHeaders completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                        if (200 == httpResponse.statusCode && !error) {
                            NSArray *currencies = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                            completionHandler(YES, currencies, nil);
                        }else{
                            completionHandler(NO, nil, nil);
                        }
                    }else{
                        completionHandler(NO, nil, error);
                    }
                }];
            }else{
                completionHandler(NO, nil, httpError);
            }
        }];
    }
}

- (void)getConfigWithCompletionHandler:(void (^)(bool successful, NSDictionary *config, NSError *httpError))completionHandler{
    NSMutableDictionary *httpAdditionalHeaders = [[NSMutableDictionary alloc] init];
    NSString *endpoint = [self getUrlForEndpoint:@"config"];
    [self get:endpoint httpAdditionalHeaders:httpAdditionalHeaders completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (200 == httpResponse.statusCode && !error) {
                NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                completionHandler(YES, config, nil);
            }else{
                completionHandler(NO, nil, nil);
            }
        }else{
            completionHandler(NO, nil, error);
        }
    }];
}

- (void)getSuggestionsWithCompletionHandler:(void (^)(bool successful, NSArray *suggestions, NSError *httpError))completionHandler{
    if (self.endpoints){
        NSMutableDictionary *httpAdditionalHeaders = [[NSMutableDictionary alloc] init];
        NSString *endpoint = [self getUrlForEndpoint:@"strategy"];
        [self get:endpoint httpAdditionalHeaders:httpAdditionalHeaders completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (200 == httpResponse.statusCode && !error) {
                    NSArray *suggestions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    completionHandler(YES, suggestions, nil);
                }else{
                    completionHandler(NO, nil, nil);
                }
            }else{
                completionHandler(NO, nil, error);
            }
        }];
    }else{
        [self getHomeWithCompletionHandler:^(bool successful, NSError *httpError) {
            if (successful){
                NSMutableDictionary *httpAdditionalHeaders = [[NSMutableDictionary alloc] init];
                NSString *endpoint = [self getUrlForEndpoint:@"strategy"];
                [self get:endpoint httpAdditionalHeaders:httpAdditionalHeaders completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                        if (200 == httpResponse.statusCode && !error) {
                            NSArray *suggestions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                            completionHandler(YES, suggestions, nil);
                        }else{
                            completionHandler(NO, nil, nil);
                        }
                    }else{
                        completionHandler(NO, nil, error);
                    }
                }];
            }
        }];
    }
}

- (void)patchConfig:(NSDictionary *)config withCompletionHandler:(void (^)(bool successful, NSDictionary *config, NSError *httpError))completionHandler{
    NSMutableDictionary *httpAdditionalHeaders = [[NSMutableDictionary alloc] init];
    NSString *endpoint = [self getUrlForEndpoint:@"config"];
    [self patch:endpoint httpAdditionalHeaders:httpAdditionalHeaders data:config completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (200 == httpResponse.statusCode && !error) {
                NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                completionHandler(YES, config, nil);
            }else{
                completionHandler(NO, nil, nil);
            }
        }else{
            completionHandler(NO, nil, error);
        }
    }];
}

- (void)buyCurrency:(NSString *)currency forAmount:(NSInteger)amount withCompletionHandler:(void (^)(bool successful, NSDictionary *trade, NSError *httpError))completionHandler{
    NSMutableDictionary *httpAdditionalHeaders = [[NSMutableDictionary alloc] init];
    NSString *endpoint = [self getUrlForEndpoint:@"buy"];
    endpoint = [endpoint stringByReplacingOccurrencesOfString:@"{currencyId}" withString:currency];
    endpoint = [endpoint stringByAppendingString:[NSString stringWithFormat:@"?amount=%ld", (long)amount]];
    [self get:endpoint httpAdditionalHeaders:httpAdditionalHeaders completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (200 == httpResponse.statusCode && !error) {
                NSDictionary *trade = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                completionHandler(YES, trade, nil);
            }else{
                completionHandler(NO, nil, nil);
            }
        }else{
            completionHandler(NO, nil, error);
        }
    }];
}

- (void)sellCurrency:(NSString *)currency forAmount:(double)amount withCompletionHandler:(void (^)(bool successful, NSDictionary *trade, NSError *httpError))completionHandler{
    NSMutableDictionary *httpAdditionalHeaders = [[NSMutableDictionary alloc] init];
    NSString *endpoint = [self getUrlForEndpoint:@"sell"];
    endpoint = [endpoint stringByReplacingOccurrencesOfString:@"{currencyId}" withString:currency];
    endpoint = [endpoint stringByAppendingString:[NSString stringWithFormat:@"?amount=%f", amount]];
    [self get:endpoint httpAdditionalHeaders:httpAdditionalHeaders completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (200 == httpResponse.statusCode && !error) {
                NSDictionary *trade = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                completionHandler(YES, trade, nil);
            }else{
                completionHandler(NO, nil, nil);
            }
        }else{
            completionHandler(NO, nil, error);
        }
    }];
}


@end
