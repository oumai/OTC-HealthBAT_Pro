//
//  BATMyOrderCell.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyOrderCell.h"

#import "UIColor+HNExtensions.h"
#import "NSAttributedString+ParagraphStyle.h"
#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]
@interface BATMyOrderCell()

@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation BATMyOrderCell

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
        
        
        self.iconImage = [UIImageView new];
        self.iconImage.image = [UIImage imageNamed:@""];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImage];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = KHexColor(@"#555555");
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = [NSString stringWithFormat:@""];
        [self.contentView addSubview:_titleLabel];
        
        self.arrowImage = [UIImageView new];
        self.arrowImage.image = [UIImage imageNamed:@"icon_arrow_right"];
        [self.contentView addSubview:_arrowImage];
        
    
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
        [self.contentView addSubview:_lineView];
        
      
        
      
        
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
  
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0.f);
            make.left.equalTo(self.iconImage.mas_right).offset(10.0f);
            make.width.equalTo(self.titleLabel.mas_width);
            make.height.equalTo(@14);
        }];
    
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(@(SCREEN_WIDTH-10));
            make.height.equalTo(@0.8);
        }];

        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.width.equalTo(@7);
            make.height.equalTo(@11);
        }];
        
        
    }
    return self;
}
@end
