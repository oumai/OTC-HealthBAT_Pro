//
//  BATOTCPayView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCPayView.h"
#import "BATConfrimPayOptionsTableViewCell.h"

@interface BATOTCPayView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIControl *control;

@property (nonatomic,strong) UIView *bgView;

@end

@implementation BATOTCPayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
        
        _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView registerClass:[BATConfrimPayOptionsTableViewCell class] forCellReuseIdentifier:@"BATConfrimPayOptionsTableViewCell"];
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

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.frame.size.width - 30, headerView.frame.size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorFromHEX(0x666666, 1);
        titleLabel.text = @"选择支付方式";
        
        [headerView addSubview:titleLabel];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATConfrimPayOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATConfrimPayOptionsTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.optionsTitleLabel.text = @"支付宝支付";
        cell.optionsImageView.image = [UIImage imageNamed:@"icon-zhifubao"];
    }
    else if (indexPath.row == 1) {
        cell.optionsTitleLabel.text = @"微信支付";
        cell.optionsImageView.image = [UIImage imageNamed:@"icon-weixin-11"];
    }
    else if (indexPath.row == 2) {
        cell.optionsTitleLabel.text = @"康美钱包";
        cell.optionsImageView.image = [UIImage imageNamed:@"icon_kmpay"];
    }
    
    if (_selectIndexPath.row == indexPath.row) {
        cell.selectImageView.image = [UIImage imageNamed:@"btn-wicon-s"];
    } else {
        cell.selectImageView.image = [UIImage imageNamed:@"btn-wicon"];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_selectIndexPath != indexPath) {
            _selectIndexPath = indexPath;
            [tableView reloadData];
        }
    }
}

#pragma mark - Action
- (void)show
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
        
    } completion:nil];
}

- (void)hide
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:nil];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.control];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.tableView];
    [self.bgView addSubview:self.confirmPayBtn];
    
    WEAK_SELF(self);
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.left.bottom.equalTo(self);
        make.height.mas_offset(350);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self.bgView);
        make.bottom.equalTo(self.confirmPayBtn.mas_top);
    }];
    
    [self.confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-35);
        make.width.equalTo(self.bgView.mas_width).offset(-20);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIControl *)control
{
    if (_control == nil) {
        _control = [[UIControl alloc] init];
        _control.backgroundColor = [UIColor blackColor];
        _control.alpha = 0.5f;
        
        WEAK_SELF(self);
        [_control bk_whenTapped:^{
            STRONG_SELF(self);
            [self hide];
            
            if (self.controlBlock) {
                self.controlBlock();
            }
        }];
    }
    return _control;
}

- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (BATGraditorButton *)confirmPayBtn{
    if (!_confirmPayBtn) {
        _confirmPayBtn = [[BATGraditorButton alloc] init];
        [_confirmPayBtn setTitle:@"确认支付" forState:UIControlStateNormal] ;
        _confirmPayBtn.enablehollowOut = YES;
        _confirmPayBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _confirmPayBtn.titleColor = [UIColor whiteColor];
        [_confirmPayBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _confirmPayBtn.layer.cornerRadius = 6.0f;
        _confirmPayBtn.layer.masksToBounds = YES;
    }
    
    return _confirmPayBtn;
}

@end
