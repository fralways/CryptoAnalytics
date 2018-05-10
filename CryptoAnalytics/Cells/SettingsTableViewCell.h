//
//  SettingsSliderTableViewCell.h
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/10/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsTableViewCellDelegate<NSObject>

@optional
- (void)sliderValueChanged:(double)value withTag:(NSInteger)tag;
    
@end

@interface SettingsTableViewCell : UITableViewCell

@property (weak) id <SettingsTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtitle;

@end
