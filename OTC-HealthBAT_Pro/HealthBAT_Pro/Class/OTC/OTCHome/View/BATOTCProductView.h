//
//  BATOTCProductView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATOTCDrugModel.h"

@class BATOTCProductView;
@protocol BATOTCProductViewDelegate<NSObject>

- (void)BATOTCProductViewDelegateWithModel:(OTCSearchData *)model;
- (void)BATOTCProductViewAddActionDelegateWithModel:(OTCSearchData *)model;
- (void)BATOTCProductViewReduceActionDelegateWithModel:(OTCSearchData *)model;

@end

@interface BATOTCProductView : UIView

@property (nonatomic,strong) NSMutableArray *shoppingData;

@property (nonatomic,strong) UITableView *product;

@property(nonatomic,weak) id <BATOTCProductViewDelegate> delegate;

@end
