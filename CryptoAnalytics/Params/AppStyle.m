//
//  AppStyle.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/29/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "AppStyle.h"

@implementation AppStyle

static float _cellFontSize;
static UIColor *_primaryColor;
static UIColor *_primaryLightColor;
static UIColor *_primaryDarkColor;
static UIColor *_primaryTextColor;
static UIColor *_primaryIncreaseColor;
static UIColor *_primaryDecreaseColor;

+ (float)cellFontSize {
    if (_cellFontSize == 0) {
        _cellFontSize = 14;
    }
    return _cellFontSize;
}

+ (UIColor *)primaryColor {
    if (_primaryColor == NULL) {
        _primaryColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.31 alpha:1.0];
    }
    return _primaryColor;
}

+ (UIColor *)primaryLightColor {
    if (_primaryLightColor == NULL) {
        _primaryLightColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.49 alpha:1.0];
    }
    return _primaryLightColor;
}

+ (UIColor *)primaryDarkColor {
    if (_primaryDarkColor == NULL) {
        _primaryDarkColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.16 alpha:1.0];
    }
    return _primaryDarkColor;
}

+ (UIColor *)primaryTextColor {
    if (_primaryTextColor == NULL) {
        _primaryTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    return _primaryTextColor;
}

+ (UIColor *)primaryIncreaseColor {
    if (_primaryIncreaseColor == NULL) {
        _primaryIncreaseColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.51 alpha:1.00];
    }
    return _primaryIncreaseColor;
}

+ (UIColor *)primaryDecreaseColor {
    if (_primaryDecreaseColor == NULL) {
        _primaryDecreaseColor = [UIColor colorWithRed:0.98 green:0.42 blue:0.38 alpha:1.00];
    }
    return _primaryDecreaseColor;
}



@end
