//
//  BATEditPersonalInfoController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATEditPersonalInfoController.h"
#import "UITextView+InputLimit.h"
#import "UITextView+Placeholder.h"



@interface BATEditPersonalInfoController ()<UITextViewDelegate, UITextFieldDelegate>

/** textView */
@property (nonatomic, strong) UITextView * textView;
/** textFiled */
@property (nonatomic, strong) UITextField * textFiled;
/** 导航栏确定按钮 */
@property (nonatomic, strong) UIBarButtonItem *rightItem;
/** 文字个数显示 */
@property (nonatomic, strong) UILabel * textCountLabel;
/** 输入的内容 */
@property (nonatomic, strong) NSString * content;

@end

@implementation BATEditPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNav];
}
- (void)setupUI{
    if ([self.title isEqualToString:@"昵称"]) {
        [self.view addSubview:self.textFiled];
        self.textFiled.text = self.textViewText;
    }else{
        [self.view addSubview:self.textView];
        self.textView.placeholder = _placehoder;
        self.textCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)self.textViewText.length,(long)_maxInputLimit];
        self.textView.text = self.textViewText;
        self.textView.maxLength = _maxInputLimit;
        [self.textView becomeFirstResponder];
    }
}
- (void)setupNav{
    
    UIButton *rightButton = [[UIButton  alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    rightButton.backgroundColor = [UIColor redColor];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitle:@"确定" forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"icon_right_save"] forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"icon_right_save"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(rightBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItme;
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
}

- (void)rightBarItemClick:(UIButton *)rightButton{
    
    NSLog(@"-----");
    if ([self.title isEqualToString:@"昵称"] && !self.textFiled.text) {
        [self showText:[NSString stringWithFormat:@"昵称不能为空"]];
        return;
    }
    self.content = [self.title isEqualToString:@"昵称"] ? self.textFiled.text : self.textView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(editPersonalInfoControllerDoneButtonDidClick:editType:)]) {
        [self.delegate editPersonalInfoControllerDoneButtonDidClick:self.content editType:self.editType];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

#pragma mark - UITextViewDelagte
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length >self.maxInputLimit) {
        [self showText:[NSString stringWithFormat:@"%@最多只能输入%ld个字",self.title,(long)self.maxInputLimit]];
    }else{
        self.rightItem.enabled = (![textView.text isEqualToString:self.textViewText]) ||  (!textView.text.length);
        self.textCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)textView.text.length,(long)_maxInputLimit];
    }
}

#pragma mark - lazy load
- (UILabel *)textCountLabel{
    if (!_textCountLabel) {
        _textCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- (60 + 10), self.textView.height - 30, 60, 30)];
        _textCountLabel.textColor = [UIColor greenColor];
        _textCountLabel.font = [UIFont systemFontOfSize:15];
        _textCountLabel.backgroundColor = [UIColor redColor];
    }
    return _textCountLabel;
}
- (UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH -20, 50)];
        _textFiled.delegate = self;
        _textFiled.backgroundColor = [UIColor grayColor];
        _textFiled.placeholder = @"请输入昵称";
        
    }
    return _textFiled;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 300)];
        _textView.backgroundColor = [UIColor grayColor];
        _textView.placeholderColor = [UIColor redColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        [_textView addSubview:self.textCountLabel];
    }
    return _textView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
