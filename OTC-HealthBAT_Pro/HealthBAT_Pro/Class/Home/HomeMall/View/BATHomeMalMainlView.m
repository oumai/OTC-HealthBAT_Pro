//
//  BATHomeMallView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeMalMainlView.h"

@implementation BATHomeMalMainlView

- (void)awakeFromNib {
    
    [super awakeFromNib];
  //  self.userInteractionEnabled = YES;
    self.drugTitle.font = [UIFont systemFontOfSize:12];
    self.drugTitle.textColor = UIColorFromRGB(51, 51, 51, 1);
    
    self.OTCDrugTitle.font = [UIFont systemFontOfSize:12];
    self.OTCDrugTitle.textColor = UIColorFromRGB(51, 51, 51, 1);
    
    self.OTCdrugContent.font = [UIFont systemFontOfSize:9];
    self.OTCdrugContent.text = @"患者自选、自购、自用\n的药物";
    self.OTCdrugContent.textColor = UIColorFromRGB(153, 153, 153, 1);
    
    self.drugConten.font = [UIFont systemFontOfSize:9];
    self.drugConten.text = @"需在职业药师\n指导下购买";
    self.drugConten.textColor = UIColorFromRGB(153, 153, 153, 1);
    
    self.drugTypeLb.font = [UIFont systemFontOfSize:10];
    self.drugTypeLb.textColor = [UIColor whiteColor];
    self.drugTypeLb.clipsToBounds = YES;
    self.drugTypeLb.layer.cornerRadius = 5;
    self.drugTypeLb.backgroundColor = UIColorFromRGB(253, 165, 8, 1);
    self.drugTypeLb.text = @"处方药";
    
    self.OTCDrugTypeLb.font = [UIFont systemFontOfSize:10];
    self.OTCDrugTypeLb.textColor = [UIColor whiteColor];
    self.OTCDrugTypeLb.clipsToBounds = YES;
    self.OTCDrugTypeLb.layer.cornerRadius = 5;
    self.OTCDrugTypeLb.backgroundColor = UIColorFromRGB(253, 165, 8, 1);
    self.OTCDrugTypeLb.text = @"非处方药";
    
    self.backView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftAction)];
   // self.leftImage.userInteractionEnabled = YES;
    [self.leftImage addGestureRecognizer:leftTap];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction)];
   // self.rightImage.userInteractionEnabled = YES;
    [self.rightImage addGestureRecognizer:rightTap];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.drugTitle.font = [UIFont systemFontOfSize:15];
        self.drugTitle.textColor = [UIColor blackColor];
        
        self.OTCDrugTitle.font = [UIFont systemFontOfSize:15];
        self.OTCDrugTitle.textColor = [UIColor blackColor];
        
        self.OTCdrugContent.font = [UIFont systemFontOfSize:12];
        self.OTCdrugContent.text = @"需在药店由职业\n药师指导下购买和使用";
        self.OTCdrugContent.textColor = [UIColor blackColor];
        
        self.drugConten.font = [UIFont systemFontOfSize:12];
        self.drugConten.text = @"可在药店出售\n还可在经验食品药品...";
        self.drugConten.textColor = [UIColor blackColor];
        
        self.drugTypeLb.font = [UIFont systemFontOfSize:15];
        self.drugTypeLb.textColor = [UIColor whiteColor];
        self.drugTypeLb.clipsToBounds = YES;
        self.drugTypeLb.layer.cornerRadius = 5;
        self.drugTypeLb.backgroundColor = [UIColor orangeColor];
        self.drugTypeLb.text = @"处方药";
        
        self.OTCDrugTypeLb.font = [UIFont systemFontOfSize:15];
        self.OTCDrugTypeLb.textColor = [UIColor whiteColor];
        self.OTCDrugTypeLb.clipsToBounds = YES;
        self.OTCDrugTypeLb.layer.cornerRadius = 5;
        self.OTCDrugTypeLb.backgroundColor = [UIColor orangeColor];
        self.OTCDrugTypeLb.text = @"非处方药";
        
        self.backView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftAction)];
      //  self.leftImage.userInteractionEnabled = YES;
        [self.leftImage addGestureRecognizer:leftTap];
        
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction)];
       // self.rightImage.userInteractionEnabled = YES;
        [self.rightImage addGestureRecognizer:rightTap];
        
        
    }
    return self;
    
}

- (void)leftAction {
    
    if (self.leftImageBlock) {
        self.leftImageBlock();
    }
}

- (void)rightAction {
    
    if (self.rightImageBlock) {
        self.rightImageBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
