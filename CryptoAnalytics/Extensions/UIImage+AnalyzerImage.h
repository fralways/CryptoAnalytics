//
//  UIImage+AnalyzerImage.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/29/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AnalyzerImage)

- (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)convertImageToGrayScale;

@end
