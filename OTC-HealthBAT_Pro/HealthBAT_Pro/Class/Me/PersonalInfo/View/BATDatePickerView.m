//
//  BATDatePickerView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDatePickerView.h"

@interface BATDatePickerView ()

@property (nonatomic,copy) NSString *dateString;

@end

@implementation BATDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _toolBar = [[UIToolbar alloc] init];
    [self addSubview:_toolBar];
    
    WEAK_SELF(self);
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        [self hide];
    }];
    
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *confirmBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确定" style:UIBarButtonItemStylePlain handler:^(id sender) {
        STRONG_SELF(self);
        [self hide];
        if (self.delegate && [self.delegate respondsToSelector:@selector(BATDatePickerView:didSelectDate:)]) {
            [self.delegate BATDatePickerView:self didSelectDate:_selectDate];
        }
    }];
    
    _toolBar.items = @[cancelBarButtonItem,fix,confirmBarButtonItem];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_datePicker];
    

    _datePicker.minimumDate = [self formatterStringToDate:@"1940-01-01"];
    _datePicker.maximumDate = [NSDate date];
    
    [self setupConstraints];

}

#pragma mark private

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(_toolBar.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

// formatter yyyy-MM-dd
- (NSDate *)formatterStringToDate:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:string];
}

- (NSString *)formatterDateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark Action
- (void)show
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dateChange:(UIDatePicker *)datePicker
{
    _selectDate = [self formatterDateToString:datePicker.date];
}

#pragma mark set & get
- (void)setSelectDate:(NSString *)selectDate
{
    _selectDate = selectDate;
    _datePicker.date = [self formatterStringToDate:selectDate];
}

@end
