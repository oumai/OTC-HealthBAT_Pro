//
//  BATSearchFiledCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSearchFiledCell.h"

@interface BATSearchFiledCell()<UITextFieldDelegate>


@end


@implementation BATSearchFiledCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索图标"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.frame = CGRectMake(0, 0, 22, 14);
    self.searchFiled.leftView=image;
    self.searchFiled.leftViewMode = UITextFieldViewModeAlways;
    self.searchFiled.delegate = self;
    self.searchFiled.backgroundColor = UIColorFromRGB(246, 246, 246, 1);
    self.searchFiled.returnKeyType = UIReturnKeySearch;
 //   [self.searchFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self setBottomBorderWithColor:UIColorFromRGB(246, 246, 246, 1) width:SCREEN_WIDTH height:0];
    
}

//- (void)textFieldDidChange:(UITextField *)textField {
//
//    if ([self.delegate respondsToSelector:@selector(textfiledidChangeWithText:)]) {
//        [self.delegate textfiledidChangeWithText:textField.text];
//    }
//
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(textfileShouldReturnWithText:textField:)]) {
        [self.delegate textfileShouldReturnWithText:textField.text textField:textField];
    }
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
