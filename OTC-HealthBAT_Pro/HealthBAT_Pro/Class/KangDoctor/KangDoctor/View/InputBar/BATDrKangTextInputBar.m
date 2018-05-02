//
//  BATKangDoctorInputBar.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangTextInputBar.h"
#import "MQAssetUtil.h"

@implementation BATDrKangTextInputBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        WEAK_SELF(self);
        
        [self addSubview:self.microphoneButton];
        [self.microphoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.bottom.equalTo(@-7.5);
            make.size.mas_equalTo(CGSizeMake(34, 34));
        }];
        
//        [self addSubview:self.sendButton];
//        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(@-10);
//            make.width.mas_equalTo(60);
//            make.height.mas_equalTo(30);
//            make.bottom.equalTo(@-9.5);
//        }];
        
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            
            make.left.equalTo(self.microphoneButton.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(@-9.5);
            make.top.equalTo(@9.5);
        }];
    }
    return self;
}

#pragma mark - action
- (void)changeToSoundInput {

    if (self.changeToSoundInputBlock) {
        self.changeToSoundInputBlock();
    }
}

- (void)sendTextMessage {
    
    if (self.sendTextMessageBlock) {
        self.sendTextMessageBlock();
    }
}

#pragma mark - getter
- (UIButton *)microphoneButton {
    
    if (!_microphoneButton) {
        _microphoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_microphoneButton setImage: [MQAssetUtil imageFromBundleWithName:@"MQMessageVoiceInputImageNormalStyleOne"] forState:UIControlStateNormal];
        [_microphoneButton addTarget:self action:@selector(changeToSoundInput) forControlEvents:UIControlEventTouchUpInside];
    }
    return _microphoneButton;
}

- (YYTextView *)textView {
    
    if (!_textView) {
        _textView = [[YYTextView alloc] initWithFrame:CGRectZero];
        _textView.layer.cornerRadius = 5.0f;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = BASE_LINECOLOR.CGColor;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.placeholderText = @"";
        _textView.layer.borderColor = BASE_LINECOLOR.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.returnKeyType = UIReturnKeySend;
    
    }
    return _textView;
}

//- (UIButton *)sendButton {
//    
//    if (!_sendButton) {
//        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
//        _sendButton.backgroundColor = BASE_COLOR;
//        _sendButton.layer.cornerRadius = 5.0f;
//        [_sendButton addTarget:self action:@selector(sendTextMessage) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _sendButton;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
