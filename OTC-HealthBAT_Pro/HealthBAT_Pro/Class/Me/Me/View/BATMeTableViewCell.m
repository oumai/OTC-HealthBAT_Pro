//
//  BATMeTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMeTableViewCell.h"

@implementation BATMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] init];
        //        _titleLabel.font = [UIFont systemFontOfSize:15];
        //        _titleLabel.textColor = UIColorFromRGB(102, 102, 102, 1);
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        [self.contentView addSubview:_titleLabel];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_offset(CGSizeMake(27, 27));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).mas_offset(10);
            make.right.bottom.top.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
