//
//  BATSelectDrugStoreView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSelectDrugStoreView.h"

@interface BATSelectDrugStoreView () <UITextFieldDelegate>



@end

@implementation BATSelectDrugStoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.topView];
    [self.topView addSubview:self.searchTF];
    [self addSubview:self.tableView];
    
    WEAK_SELF(self);
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.left.right.equalTo(self);
        make.height.mas_offset(50);
    }];
    
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.topView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

#pragma mark - get & set

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UITextField *)searchTF
{
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:13] textColor:nil placeholder:@"搜索" BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchTF.textColor = STRING_LIGHT_COLOR;
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索图标"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 30);
        _searchTF.backgroundColor = BASE_BACKGROUND_COLOR;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        
        _searchTF.layer.cornerRadius = 3.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
