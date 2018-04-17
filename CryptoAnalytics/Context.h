//
//  Context.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 3/2/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Context : NSObject

+ (Context *)sharedContext;

@property NSString *host;

@end
