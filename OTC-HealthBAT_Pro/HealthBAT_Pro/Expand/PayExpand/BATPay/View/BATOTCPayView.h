//
//  BATOTCPayView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

typedef void(^ControlBlock)(void);

@interface BATOTCPayView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) BATGraditorButton *confirmPayBtn;

@property (nonatomic,strong) NSIndexPath *selectIndexPath;

@property (nonatomic,strong) ControlBlock controlBlock;

- (void)show;

- (void)hide;

@end
