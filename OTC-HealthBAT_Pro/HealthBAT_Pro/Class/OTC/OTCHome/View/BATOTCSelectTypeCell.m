//
//  BATOTCSelectTypeCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCSelectTypeCell.h"

@implementation BATOTCSelectTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lineView.backgroundColor = UIColorFromRGB(224, 224, 224, 1);
    
    self.leftView.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftClick)];
    [self.leftView addGestureRecognizer:leftTap];
    
    self.rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick)];
    [self.rightView addGestureRecognizer:rightTap];
    
}

- (void)leftClick {
    
    if ([self.delegate respondsToSelector:@selector(BATOTCSelectTypeCellDelegateLeftClickAction)]) {
        [self.delegate BATOTCSelectTypeCellDelegateLeftClickAction];
    }
    
}

- (void)rightClick {
    
    if ([self.delegate respondsToSelector:@selector(BATOTCSelectTypeCellDelegateRightClickAction)]) {
        [self.delegate BATOTCSelectTypeCellDelegateRightClickAction];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
