//
//  BATSubmitOrderView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATSubmitOrderView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *footView;

@property (nonatomic,strong) UILabel *totalTitleLabel;

@property (nonatomic,strong) UILabel *totalPriceLabel;

@property (nonatomic,strong) BATGraditorButton *submitButton;

@end
