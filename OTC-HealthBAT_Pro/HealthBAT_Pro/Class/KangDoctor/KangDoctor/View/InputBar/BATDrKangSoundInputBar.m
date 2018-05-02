//
//  BATKangDoctorSoundInputBar.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangSoundInputBar.h"

@implementation BATDrKangSoundInputBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        WEAK_SELF(self);
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        
        [self addSubview:self.microphoneButton];
        [self.microphoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@10);
        }];
        
        [self addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.microphoneButton.mas_bottom).offset(10);
            make.centerX.equalTo(@0);
        }];
    }
    return self;
}

#pragma mark - YYTextViewDelegate


#pragma mark - action
- (void)recognizerBegin {
    
    if (self.recognizerBeginBlock) {
        self.recognizerBeginBlock();
    }
}

- (void)recognizerStop {
    
    if (self.recognizerStopBlock) {
        self.recognizerStopBlock();
    }
}

- (void)recognizerAlert {
  
    if (self.recognizerAlertBlock) {
        self.recognizerAlertBlock();
    }
}
- (void)recognizerCancel {
    
    if (self.recognizerCancelBlock) {
        self.recognizerCancelBlock();
    }
}
- (void)recognizerContinue {
    
    if (self.recognizerContinueBlock) {
        self.recognizerContinueBlock();
    }
}

#pragma mark - getter
- (UIButton *)microphoneButton {
    
    if (!_microphoneButton) {
        _microphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_microphoneButton setBackgroundImage:[UIImage imageNamed:@"icon-nor-cajh"] forState:UIControlStateNormal];
        [_microphoneButton sizeToFit];
        
        [_microphoneButton addTarget:self action:@selector(recognizerBegin) forControlEvents:UIControlEventTouchDown];
        [_microphoneButton addTarget:self action:@selector(recognizerStop) forControlEvents:UIControlEventTouchUpInside];
        [_microphoneButton addTarget:self action:@selector(recognizerAlert) forControlEvents:UIControlEventTouchDragExit];
        [_microphoneButton addTarget:self action:@selector(recognizerCancel) forControlEvents:UIControlEventTouchUpOutside];
        [_microphoneButton addTarget:self action:@selector(recognizerContinue) forControlEvents:UIControlEventTouchDragEnter];
        
    }
    return _microphoneButton;
}

- (UILabel *)bottomLabel {
    
    if (!_bottomLabel) {
        
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLabel.font = [UIFont systemFontOfSize:15];
        _bottomLabel.textColor = UIColorFromHEX(0x333333, 1);
        _bottomLabel.text = @"长按讲话";
        [_bottomLabel sizeToFit];
    }
    return _bottomLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
