//
//  BATResultCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATResultCell.h"

@implementation BATResultCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.resultString.textColor = UIColorFromRGB(51, 51, 51, 1);

    self.backvView.backgroundColor = UIColorFromRGB(241, 241, 243, 1);
}

- (void)setContent:(NSString *)content {
    
    _content = content;
    
    self.resultString.text = content;
    
    self.backvView.backgroundColor = [UIColor whiteColor];
    
}

- (void)setTags:(NSString *)tags {
    
    _tags = tags;
    
    NSArray *arr = [tags componentsSeparatedByString:@","];
    NSString *heightPressureTag = arr[0];
    NSString *bloodOxygen = arr[1];
    NSString *heartRateTag = arr[2];
    
    if ([heightPressureTag isEqualToString:@"低血压"]) {
        heightPressureTag = @"偏低";
    }else if([heightPressureTag isEqualToString:@"保健品"]) {
        heightPressureTag = @"正常";
    }else {
        heightPressureTag = @"偏高";
        
    }
    
    if ([bloodOxygen isEqualToString:@"血氧低"]) {
        bloodOxygen = @"偏低";
    }else if([bloodOxygen isEqualToString:@"保健品"]) {
        bloodOxygen = @"正常";
    }else {
        bloodOxygen = @"偏高";
        
    }
    
    if ([heartRateTag isEqualToString:@"心率不齐"]) {
        heartRateTag = @"偏低";
    }else if([heartRateTag isEqualToString:@"保健品"]) {
        heartRateTag = @"正常";
    }else {
        heartRateTag = @"偏高";
        
    }
    
    NSString *content = [NSString stringWithFormat:@"您的心率测量值%@,血压值%@,血氧值%@，请培养健康生活方式",heartRateTag,heightPressureTag,bloodOxygen];
    NSMutableAttributedString *descAttributedStr  = [[NSMutableAttributedString alloc]initWithString:content];

    NSRange range1 = NSMakeRange(7, 2);
    [descAttributedStr addAttribute:NSForegroundColorAttributeName

                              value:UIColorFromRGB(84, 156, 67, 1)

                              range:range1];
    
    NSRange range2 = NSMakeRange(13, 2);
    [descAttributedStr addAttribute:NSForegroundColorAttributeName
     
                              value:UIColorFromRGB(84, 156, 67, 1)
     
                              range:range2];

    NSRange range3 = NSMakeRange(19, 2);
    [descAttributedStr addAttribute:NSForegroundColorAttributeName
     
                              value:UIColorFromRGB(84, 156, 67, 1)
     
                              range:range3];

    self.resultString.attributedText = descAttributedStr;
//    heightPressureTag,bloodOxygen,heartRateTag
    //您的心率测量值偏低，血压值正常，血氧值正常，请培养健康生活方式。
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
