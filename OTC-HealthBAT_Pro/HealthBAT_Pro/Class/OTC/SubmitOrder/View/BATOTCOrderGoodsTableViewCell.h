//
//  BATOTCOrderGoodsTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATOTCOrderGoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellPriceLabel;

@end
