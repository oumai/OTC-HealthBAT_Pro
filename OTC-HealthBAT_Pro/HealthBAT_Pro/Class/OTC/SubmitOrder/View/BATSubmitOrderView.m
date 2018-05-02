//
//  BATSubmitOrderView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSubmitOrderView.h"

@implementation BATSubmitOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self pageLayout];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    [self addSubview:self.footView];
    [self.footView addSubview:self.totalTitleLabel];
    [self.footView addSubview:self.totalPriceLabel];
    [self.footView addSubview:self.submitButton];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.footView.mas_top);
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self);
        make.height.mas_offset(50);
    }];
    
    [self.totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.footView.mas_left).offset(10);
        make.centerY.equalTo(self.footView.mas_centerY);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.totalTitleLabel.mas_right);
        make.centerY.equalTo(self.footView.mas_centerY);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(134, 50));
        make.right.equalTo(self.footView.mas_right);
        make.centerY.equalTo(self.footView.mas_centerY);
    }];
    
    [self.footView setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
    }
    return _tableView;
}

- (UIView *)footView
{
    if (_footView == nil) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = [UIColor whiteColor];
        _footView.hidden = YES;
    }
    return _footView;
}

- (UILabel *)totalTitleLabel
{
    if (_totalTitleLabel == nil) {
        _totalTitleLabel = [[UILabel alloc] init];
        _totalTitleLabel.text = @"合计：";
        _totalTitleLabel.font = [UIFont systemFontOfSize:18];
        _totalTitleLabel.textColor = STRING_DARK_COLOR;
        [_totalTitleLabel sizeToFit];
    }
    return _totalTitleLabel;
}

- (UILabel *)totalPriceLabel
{
    if (_totalPriceLabel == nil) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.text = @"20.00元";
        _totalPriceLabel.font = [UIFont systemFontOfSize:18];
        _totalPriceLabel.textColor = UIColorFromHEX(0xff8f2b, 1);
        [_totalPriceLabel sizeToFit];
    }
    return _totalPriceLabel;
}

- (BATGraditorButton *)submitButton
{
    if (_submitButton == nil) {
        _submitButton = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        _submitButton.titleColor = [UIColor whiteColor];
        _submitButton.enablehollowOut = YES;
        [_submitButton setGradientColors:@[START_COLOR,END_COLOR]];
        
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _submitButton;
}

@end
