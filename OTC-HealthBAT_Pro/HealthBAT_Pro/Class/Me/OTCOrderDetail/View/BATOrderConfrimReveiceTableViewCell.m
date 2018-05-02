//
//  BATOrderConfrimReveiceTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOrderConfrimReveiceTableViewCell.h"

@implementation BATOrderConfrimReveiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.confrimReveiceBtn.layer.cornerRadius = 15;
    self.confrimReveiceBtn.layer.borderColor = UIColorFromHEX(0xff7200, 1).CGColor;
    self.confrimReveiceBtn.layer.borderWidth = 0.5;
    
    [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
