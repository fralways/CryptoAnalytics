//
//  AppStyle.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/29/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppStyle : NSObject

@property (readonly, class) float cellFontSize;
@property (readonly, class) UIColor *primaryColor;
@property (readonly, class) UIColor *primaryLightColor;
@property (readonly, class) UIColor *primaryDarkColor;
@property (readonly, class) UIColor *primaryTextColor;
@property (readonly, class) UIColor *primaryIncreaseColor;
@property (readonly, class) UIColor *primaryDecreaseColor;

@end
