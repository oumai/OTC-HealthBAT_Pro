//
//  BATKangDoctorInputBar.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@interface BATDrKangTextInputBar : UIView

@property (nonatomic,strong) UIButton *microphoneButton;
@property (nonatomic,strong) YYTextView *textView;
//@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,copy) void(^sendTextMessageBlock)(void);
@property (nonatomic,copy) void(^changeToSoundInputBlock)(void);

@end
