//
//  BATOTCSelectTypeCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BATOTCSelectTypeCellDelegate<NSObject>

- (void)BATOTCSelectTypeCellDelegateLeftClickAction;
- (void)BATOTCSelectTypeCellDelegateRightClickAction;


@end

@interface BATOTCSelectTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property(nonatomic,assign) id <BATOTCSelectTypeCellDelegate> delegate;

@end
