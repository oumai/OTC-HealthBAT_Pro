//
//  BATOrderStatusSubTitleCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATOrderStatusSubTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *OrderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@end
