//
//  BATDrugStoreTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugStoreTableViewCell.h"

@implementation BATDrugStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.drugStoreImageView.layer.cornerRadius = 6.0f;
    self.drugStoreImageView.layer.masksToBounds = YES;
    
    [self setBottomBorderWithColor:BASE_LINECOLOR width:0 height:0 leftOffset:10 rightOffset:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
