//
//  BATDrugStoreTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDrugStoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *drugStoreImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
