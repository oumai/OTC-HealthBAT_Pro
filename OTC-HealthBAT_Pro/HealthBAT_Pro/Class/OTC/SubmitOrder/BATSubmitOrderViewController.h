//
//  BATSubmitOrderViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSubmitOrderView.h"
#import "BATOTCDrugModel.h"

@interface BATSubmitOrderViewController : UIViewController

@property (nonatomic,strong) BATSubmitOrderView *submitOrderView;

/**
 商品Model数组
 */
@property (nonatomic,strong) NSMutableArray *dataArry;


/**
 症状
 */
@property (nonatomic,strong) NSString *Symptom;

/**
 处方单图片地址
 */
@property (nonatomic,strong) NSString *RecipeFileUrl;

/**
 处方单ID
 */
@property (nonatomic,strong) NSString *RecipeID;

/**
 订单类型 BATOTCOrderType_PrescriptionDrugs: 处方药 ，BATOTCOrderType_NonPrescriptionDrugs: 非处方药
 */
@property (nonatomic,assign) BATOTCOrderType orderType;

@end
