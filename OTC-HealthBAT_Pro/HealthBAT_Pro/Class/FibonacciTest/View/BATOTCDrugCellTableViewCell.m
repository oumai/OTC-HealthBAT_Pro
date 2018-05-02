//
//  BATOTCDrugCellTableViewCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCDrugCellTableViewCell.h"

@implementation BATOTCDrugCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.drugName.textColor = UIColorFromRGB(51, 51, 51, 1);
    self.drugName.font = [UIFont systemFontOfSize:15];
    
    self.producterName.textColor = UIColorFromRGB(153, 153, 153, 1);
    self.producterName.font = [UIFont systemFontOfSize:12];
    
    self.salesPriceLb.textColor = [UIColor redColor];
    self.salesPriceLb.font = [UIFont systemFontOfSize:14];
    
    self.priceLb.textColor = UIColorFromRGB(153, 153, 153, 1);
    self.priceLb.font = [UIFont systemFontOfSize:11];
    
    self.addBtn.clipsToBounds = YES;
    self.addBtn.layer.cornerRadius = 10;
    [self.reduceBtn setImage:[UIImage imageNamed:@"icon-p-jq"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon-p-js"] forState:UIControlStateNormal];
    
    [self.reduceBtn setImage:[UIImage imageNamed:@"icon-n-jq"] forState:UIControlStateHighlighted];
    [self.addBtn setImage:[UIImage imageNamed:@"icon-n-js"] forState:UIControlStateHighlighted];
    
    self.reduceBtn.clipsToBounds = YES;
    self.reduceBtn.layer.cornerRadius = 10;
    
    self.photoImage.clipsToBounds = YES;
    self.photoImage.layer.cornerRadius = 5;
    self.photoImage.layer.borderWidth = 1;
    self.photoImage.layer.borderColor = UIColorFromRGB(224, 224, 224, 1).CGColor;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(153, 153, 153, 1);
    [self.priceLb addSubview:lineView];
    
    WEAK_SELF(self);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.priceLb.mas_centerY);
        make.left.right.equalTo(self.priceLb);
        make.height.mas_equalTo(1);
    }];
    
    [self setBottomBorderWithColor:UIColorFromRGB(224, 224, 224, 1) width:SCREEN_WIDTH height:0];
    
    self.priceLb.hidden = YES;
    lineView.hidden = YES;
}

- (void)setDrugModel:(OTCSearchData *)drugModel {
    
    _drugModel = drugModel;
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:drugModel.PictureUrl]];
    self.drugName.text = [NSString stringWithFormat:@"%@ %@",drugModel.DrugName,drugModel.Specification];
    self.producterName.text = drugModel.ManufactorName;
    self.salesPriceLb.text = [NSString stringWithFormat:@"¥%@",drugModel.Price];
    self.priceLb.text = @"";
    self.countLb.text = [NSString stringWithFormat:@"%zd",drugModel.drugCount];
    
}

- (IBAction)addAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(BATOTCDrugCellTableViewCellDelegateWithAddActionRowPaht:cell:)]) {
        [self.delegate BATOTCDrugCellTableViewCellDelegateWithAddActionRowPaht:self.rowPath cell:self];
    }
}
- (IBAction)reduceAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(BATOTCDrugCellTableViewCellDelegateWithReduceActionRowPaht:cell:)]) {
        [self.delegate BATOTCDrugCellTableViewCellDelegateWithReduceActionRowPaht:self.rowPath cell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
