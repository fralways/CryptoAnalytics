//
//  SetupParams.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 6/1/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface SetupParams : NSObject

@property NSInteger money;
@property STRATEGIES strategy;
@property BOOL automatic;

@end
