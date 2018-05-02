//
//  BATWillPayCell.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PharmacyOrderListModel.h"

@interface BATWillPayCell : UITableViewCell

@property (nonatomic, strong) void(^payButtonBlock)(BATWillPayCell *cell,NSIndexPath*pathRows);

@property (nonatomic,strong) OTCDrugListData *drugListData;
@property (nonatomic,strong) OTCDrugData *drugModel;
@property (nonatomic,strong) NSIndexPath *path;

@end
