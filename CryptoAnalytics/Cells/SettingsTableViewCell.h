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
- (void)sliderValueChanged:(double)value withCell:(id)cell;

@end

@interface SettingsTableViewCell : UITableViewCell

@property (weak) id <SettingsTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtitle;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)cancel:(UIButton *)sender;
- (IBAction)ok:(UIButton *)sender;


@end
