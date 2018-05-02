//
//  BATOTCOrderDetailViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATOTCOrderDetailView.h"

@interface BATOTCOrderDetailViewController : UIViewController

@property (nonatomic,strong) BATOTCOrderDetailView *orderDetailView;

/**
 订单号
 */
@property (nonatomic,strong) NSString *orderNo;

@end
