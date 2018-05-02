//
//  BATKangDoctorTextMessageTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangTextMessageTableViewCell.h"
#import "BATPerson.h"
#import "MQAssetUtil.h"

@implementation BATDrKangTextMessageTableViewCell

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
            make.trailing.equalTo(@-20);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [self.contentView addSubview:self.bubbleImageView];
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.trailing.equalTo(self.avatarImageView.mas_leading).offset(-5);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.bottom.equalTo(@-10);
            make.leading.greaterThanOrEqualTo(@(20+45+5));
        }];
        
        [self.bubbleImageView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@10);
            make.bottom.equalTo(@-8);
            make.right.equalTo(@-17);
        }];

        [self.contentView addSubview:self.failureImageView];
        [self.failureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.bubbleImageView.mas_leading).offset(-5);
            make.centerY.equalTo(self.bubbleImageView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];

        [self.contentView addSubview:self.sendingIndicator];
        [self.sendingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.bubbleImageView.mas_leading).offset(-5);
            make.centerY.equalTo(self.bubbleImageView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
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

    self.label.text = messageModel.content;

}
#pragma mark - getter
- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        BATPerson *person = PERSON_INFO;
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.bounds = CGRectMake(0, 0, 45, 45);
        _avatarImageView.layer.cornerRadius = 45/2.0;
        _avatarImageView.clipsToBounds = YES;
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:person.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
    }
    return _avatarImageView;
}
- (UIImageView *)bubbleImageView {
    
    if (!_bubbleImageView) {
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleImageView.image = [[UIImage imageNamed:@"康博士蓝色对话"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 20) resizingMode:UIImageResizingModeStretch];
    }
    return _bubbleImageView;
}

- (UILabel *)label {
    
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor whiteColor];
        _label.preferredMaxLayoutWidth = SCREEN_WIDTH-((20+45+5+10)+(20+45+5+17));
        [_label sizeToFit];
    }
    return _label;
}

- (UIActivityIndicatorView *)sendingIndicator {

    if (!_sendingIndicator) {
        _sendingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _sendingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _sendingIndicator;
}

- (UIImageView *)failureImageView {

    if (!_failureImageView) {
        _failureImageView = [[UIImageView alloc] initWithImage:[MQAssetUtil imageFromBundleWithName:@"MQMessageWarning"]];
        _failureImageView.hidden = YES;
    }
    return _failureImageView;
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
