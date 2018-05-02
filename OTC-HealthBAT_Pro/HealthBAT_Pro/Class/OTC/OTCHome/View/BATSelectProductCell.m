//
//  BATSelectProductCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSelectProductCell.h"

@implementation BATSelectProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.reduceBtn setImage:[UIImage imageNamed:@"icon-p-jq"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon-p-js"] forState:UIControlStateNormal];
    
    self.productName.textColor = UIColorFromRGB(51, 51, 51, 1);
    self.productName.font = [UIFont systemFontOfSize:15];
    
    self.producterLb.textColor = UIColorFromRGB(153, 153, 153, 1);
    self.producterLb.font = [UIFont systemFontOfSize:12];
    
    self.salesPriceLb.textColor = [UIColor redColor];
    self.salesPriceLb.font = [UIFont systemFontOfSize:14];
    
    
    self.addBtn.clipsToBounds = YES;
    self.addBtn.layer.cornerRadius = 10;
    [self.addBtn setImage:[UIImage imageNamed:@"icon-n-js"] forState:UIControlStateHighlighted];
    
    self.reduceBtn.clipsToBounds = YES;
    self.reduceBtn.layer.cornerRadius = 10;
    [self.reduceBtn setImage:[UIImage imageNamed:@"icon-n-jq"] forState:UIControlStateHighlighted];
    
    self.photoImage.clipsToBounds = YES;
    self.photoImage.layer.cornerRadius = 5;
    self.photoImage.layer.borderWidth = 1;
    self.photoImage.layer.borderColor = UIColorFromRGB(224, 224, 224, 1).CGColor;
    
    [self.selectBtn setImage:[UIImage imageNamed:@"icon-n-swmr"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"icon-p-swmr"] forState:UIControlStateSelected];
    
    [self setBottomBorderWithColor:UIColorFromRGB(224, 224, 224, 1) width:SCREEN_WIDTH height:0];
    
}

- (void)setDrugModel:(OTCSearchData *)drugModel {
    
    _drugModel = drugModel;
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:drugModel.PictureUrl]];
    self.productName.text = [NSString stringWithFormat:@"%@ %@",drugModel.DrugName,drugModel.Specification];
    self.producterLb.text = drugModel.ManufactorName;
    self.salesPriceLb.text = [NSString stringWithFormat:@"¥%@",drugModel.Price];
    self.countLb.text = [NSString stringWithFormat:@"%zd",drugModel.drugCount];
    self.selectBtn.selected = drugModel.isSelect;
    
}
- (IBAction)reduceAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(BATSelectProductCellDelegateWithReduceActionRowPaht:cell:)]) {
        [self.delegate BATSelectProductCellDelegateWithReduceActionRowPaht:self.rowPath cell:self];
    }
    
}
- (IBAction)addAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(BATSelectProductCellDelegateWithAddActionRowPaht:cell:)]) {
        [self.delegate BATSelectProductCellDelegateWithAddActionRowPaht:self.rowPath cell:self];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
