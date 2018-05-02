//
//  BATDrKangSoundTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/2/222017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangSoundTableViewCell.h"

@implementation BATDrKangSoundTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        WEAK_SELF(self);

        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@5);
            make.height.lessThanOrEqualTo(@12);
        }];

        [self.contentView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@20);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];

        [self.contentView addSubview:self.bubbleImageView];
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.leading.equalTo(self.avatarImageView.mas_trailing).offset(5);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH-((20+45+5+10)*2)-40);
        }];

        [self.bubbleImageView addSubview:self.trumpetImageView];
        [self.trumpetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.leading.equalTo(self.bubbleImageView.mas_leading).offset(15);
            make.centerY.equalTo(@0);
        }];

        [self.contentView addSubview:self.audioDurationLabel];
        [self.audioDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.leading.equalTo(self.bubbleImageView.mas_trailing).offset(5);
            make.centerY.equalTo(@0);
        }];

    }
    return self;
}

- (void)setMessageModel:(BATDrKangMessageModel *)messageModel {

    if (messageModel.isTimeVisible) {
        NSString *first = [Tools getDateStringWithDate:messageModel.time Format:@"MM-dd"];
        NSString *middle = [Tools getWeekdayStringFromDate:messageModel.time];
        NSString *end = [Tools getDateStringWithDate:messageModel.time Format:@"HH:mm"];
        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@%@",first,middle,end];
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12);
        }];
    }
    else {
        self.timeLabel.text = @"";
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }

    [self.bubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(messageModel.textWidth+10, messageModel.textHeight+10));
    }];

}


#pragma mark - getter
- (UIImageView *)avatarImageView {

    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.layer.cornerRadius = 45/2.0;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"icon-kbs"];
    }
    return _avatarImageView;
}

- (UIImageView *)bubbleImageView {

    if (!_bubbleImageView) {
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleImageView.image = [[UIImage imageNamed:@"康博士白色对话"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        _bubbleImageView.userInteractionEnabled = YES;
        _bubbleImageView.tintColor = UIColorFromRGB(0, 0, 0, 0.15);
        UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
        [_bubbleImageView addGestureRecognizer:tgr];
    }
    return _bubbleImageView;
}

- (UIImageView *)trumpetImageView {

    if (!_trumpetImageView) {
        _trumpetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-yy"]];
        [_trumpetImageView sizeToFit];
    }
    return _trumpetImageView;
}

- (UILabel *)audioDurationLabel {

    if (!_audioDurationLabel) {
        _audioDurationLabel = [[UILabel alloc] init];
        _audioDurationLabel.textColor = UIColorFromHEX(0x999999, 1);
        _audioDurationLabel.font = [UIFont systemFontOfSize:15];
        [_audioDurationLabel sizeToFit];
    }
    return _audioDurationLabel;
}

- (void)onClick {
    if (self.audioPlayerBlock) {
        self.audioPlayerBlock();
    }
}
- (UILabel *)timeLabel {

    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor grayColor];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
