//
//  BATDrKangBottomCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/2/212017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangBottomCollectionViewCell.h"

@implementation BATDrKangBottomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        
        [self.contentView addSubview:self.keyWordLabel];
        WEAK_SELF(self);
        [self.keyWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        [self.contentView addSubview:self.keyLabel];
        [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
    return self;
}

- (UILabel *)keyLabel {
    if (!_keyLabel) {
        _keyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        
        _keyLabel.layer.borderColor = UIColorFromRGB(204, 204, 204, 1).CGColor;
        _keyLabel.layer.borderWidth = 0.5f;
        _keyLabel.layer.cornerRadius = 15.f;
    }
    return _keyLabel;
}

- (BATGraditorButton *)keyWordLabel {
    if (!_keyWordLabel) {
        _keyWordLabel = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _keyWordLabel.userInteractionEnabled = NO;
        
        _keyWordLabel.layer.cornerRadius = 15.0f;
        _keyWordLabel.layer.masksToBounds = YES;
        [_keyWordLabel setGradientColors:@[START_COLOR,END_COLOR]];
        
        _keyWordLabel.enablehollowOut = YES;
        _keyWordLabel.customColor = BASE_BACKGROUND_COLOR;
        _keyWordLabel.customCornerRadius = 15.0f;
        _keyWordLabel.titleLabel.font = [UIFont systemFontOfSize:15];
        _keyWordLabel.titleColor  = [UIColor whiteColor];
    }
    return _keyWordLabel;
}

@end
