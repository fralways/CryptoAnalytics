//
//  Enums.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: NSInteger{
    SPEED   = 0,
    MACD,
    EMA,
    SMA
}STRATEGIES;

@interface Enums : NSObject

@end
