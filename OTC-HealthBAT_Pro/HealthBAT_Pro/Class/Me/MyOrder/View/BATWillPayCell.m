//
//  BATWillPayCell.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATWillPayCell.h"


#import "UIColor+HNExtensions.h"
#import "NSAttributedString+ParagraphStyle.h"
#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]
@interface BATWillPayCell()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIView *lineView0;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIButton *willPayButton; //待支付

@end


@implementation BATWillPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        
        self.lineView0 = [UIView new];
        self.lineView0.backgroundColor = KHexColor(@"#ebebeb");;
        [self.contentView addSubview:_lineView0];
        
        
        [_lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(33);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(@(SCREEN_WIDTH-10));
            make.height.equalTo(@0.5);        }];
        
        
        self.lineView1 = [UIView new];
        self.lineView1.backgroundColor = KHexColor(@"#ebebeb");BASE_BACKGROUND_COLOR;
        [self.contentView addSubview:_lineView1];
        
        
        [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(@(SCREEN_WIDTH-10));
            make.height.equalTo(@0.5);        }];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.textColor = KHexColor(@"#555555");
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.text = [NSString stringWithFormat:@"2017-10-10      18:18"];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10.0f);
            make.left.equalTo(self.contentView.mas_left).offset(10.0f);
            make.bottom.equalTo(self.lineView0.mas_top).offset(-7.f);
            make.width.equalTo(self.timeLabel.mas_width);
        }];
        
        
        
        
        self.iconImage = [UIImageView new];
        self.iconImage.image = [UIImage imageNamed:@""];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImage.layer.cornerRadius = 5;
        self.iconImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImage];
        
        self.nameLabel = [UILabel new];
        self.nameLabel.textColor = KHexColor(@"#555555");
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel.text = [NSString stringWithFormat:@"神奇全天麻胶囊24片"];
        [self.contentView addSubview:_nameLabel];
        
        
        
        
        
        
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView0.mas_bottom).offset(11);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(@90);
            make.height.equalTo(@68);
        }];
        
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0.f);
            make.left.equalTo(self.iconImage.mas_right).offset(10.0f);
            make.width.equalTo(self.nameLabel.mas_width);
            make.height.equalTo(@14);
        }];
        
        
        self.willPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.willPayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter; //标题居中
        self.willPayButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.willPayButton setTitle:@"待付款" forState:UIControlStateNormal];
        [self.willPayButton setTitleColor:KHexColor(@"#f94f4f") forState:UIControlStateNormal];
        [self.willPayButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_willPayButton];
        
        [_willPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.bottom.equalTo(self.lineView0.mas_top).offset(-0);
            make.right.equalTo(self.contentView.mas_right).offset(-0);
            make.width.equalTo(@60);
            
        }];
        
        
        
        
    }
    return self;
}
- (void)buttonClick
{
    if (self.payButtonBlock) {
        self.payButtonBlock(self, self.path);
    }
}



-(void)setDrugListData:(OTCDrugListData *)drugListData
{
    self.timeLabel.text = drugListData.CreatedTime;
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@共%ld个商品",[drugListData.ProductList firstObject].ProductName,[drugListData.ProductList firstObject].Specification,(unsigned long)drugListData.ProductList.count];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[drugListData.ProductList firstObject].ProductImage]  placeholderImage:[UIImage imageNamed:@"默认图"]];
}
@end

