//
//  BATSelectDrugStoreViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSelectDrugStoreView.h"

@interface BATSelectDrugStoreViewController : UIViewController

@property (nonatomic,strong) BATSelectDrugStoreView *selectDrugStoreView;

/**
 格式化后的商品ID和数量
 */
@property (nonatomic,strong) NSMutableArray *products;

/**
 已选药店
 */
@property (nonatomic,copy) NSString *selectDrugStore;

@end
