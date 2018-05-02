//
//  BATHomeMallView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeMalMainlView : UIView
@property (weak, nonatomic) IBOutlet UILabel *drugTitle;
@property (weak, nonatomic) IBOutlet UILabel *OTCDrugTitle;
@property (weak, nonatomic) IBOutlet UILabel *drugConten;
@property (weak, nonatomic) IBOutlet UILabel *OTCdrugContent;
@property (weak, nonatomic) IBOutlet UILabel *drugTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *OTCDrugTypeLb;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@property (nonatomic,strong) void (^leftImageBlock)(void);
@property (nonatomic,strong) void (^rightImageBlock)(void);
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
