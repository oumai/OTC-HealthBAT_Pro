//
//  BATDatePickerView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATDatePickerView;
@protocol BATDatePickerViewDelegate <NSObject>

- (void)BATDatePickerView:(BATDatePickerView *)datePickerView didSelectDate:(NSString *)dateString;

@end

@interface BATDatePickerView : UIView

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic,copy) NSString *selectDate;

@property (nonatomic,weak) id<BATDatePickerViewDelegate> delegate;

- (void)show;

- (void)hide;

@end
