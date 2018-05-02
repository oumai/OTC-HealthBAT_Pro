//
//  BATShoppingTrolleyView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BATShoppingTrolleyViewDelegate<NSObject>

- (void)BATShoppingTrolleyViewShoppingCarAction;

- (void)BATShoppingTrolleyViewCountAcion;


@end

@interface BATShoppingTrolleyView : UIView
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,weak) id <BATShoppingTrolleyViewDelegate> delegate;

@end
