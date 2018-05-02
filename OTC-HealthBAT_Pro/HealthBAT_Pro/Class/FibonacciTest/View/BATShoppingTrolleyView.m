//
//  BATShoppingTrolleyView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATShoppingTrolleyView.h"

@implementation BATShoppingTrolleyView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.priceLb.textColor = UIColorFromRGB(51, 51, 51, 1);
    self.priceLb.font = [UIFont systemFontOfSize:15];
    
    self.shoppingCarBtn.clipsToBounds = YES;
    self.shoppingCarBtn.layer.cornerRadius = 25;
    
    self.lineView.backgroundColor = UIColorFromRGB(224, 224, 224, 1);
    
}
- (IBAction)shoppingCarAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(BATShoppingTrolleyViewShoppingCarAction)]) {
        [self.delegate BATShoppingTrolleyViewShoppingCarAction];
    }
    
}
- (IBAction)countAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(BATShoppingTrolleyViewCountAcion)]) {
        [self.delegate BATShoppingTrolleyViewCountAcion];
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
