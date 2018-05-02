//
//  BATOTCOrderGoodsTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCOrderGoodsTableViewCell.h"

@implementation BATOTCOrderGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodsImageView.clipsToBounds = YES;
    self.goodsImageView.layer.cornerRadius = 5;
    self.goodsImageView.layer.borderWidth = 1;
    self.goodsImageView.layer.borderColor = UIColorFromRGB(224, 224, 224, 1).CGColor;
    
    [self setBottomBorderWithColor:BASE_LINECOLOR width:0 height:0 leftOffset:10 rightOffset:10];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
