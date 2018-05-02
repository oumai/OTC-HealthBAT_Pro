//
//  BATOrderDetailInfoTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATOrderDetailInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
