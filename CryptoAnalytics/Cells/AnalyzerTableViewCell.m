//
//  AnalyzerTableViewCell.m
//  CryptoAnalytics
//
//  Created by Filip Rajicic on 5/14/18.
//  Copyright © 2018 Filip Rajicic. All rights reserved.
//

#import "AnalyzerTableViewCell.h"

@implementation AnalyzerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(actionClickedWithTag:)]) {
        [self.delegate actionClickedWithTag:self.tag];
    }
}

@end
