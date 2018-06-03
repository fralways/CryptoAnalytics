//
//  SettingsSliderTableViewCell.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/10/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)sliderValueChanged:(UISlider *)sender{
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:withCell:)]) {
        [self.delegate sliderValueChanged:sender.value withCell:self];
    }
}

- (IBAction)cancel:(UIButton *)sender {
}

- (IBAction)ok:(UIButton *)sender {
}
@end
