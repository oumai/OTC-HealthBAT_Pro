//
//  BATKangDoctorSoundInputBar.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDrKangSoundInputBar : UIView

@property (nonatomic,strong) UIButton *microphoneButton;
@property (nonatomic,strong) UILabel *bottomLabel;

@property (nonatomic,copy) void(^recognizerBeginBlock)(void);
@property (nonatomic,copy) void(^recognizerStopBlock)(void);
@property (nonatomic,copy) void(^recognizerAlertBlock)(void);
@property (nonatomic,copy) void(^recognizerCancelBlock)(void);
@property (nonatomic,copy) void(^recognizerContinueBlock)(void);

@end
