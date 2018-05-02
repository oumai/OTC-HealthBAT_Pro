//
//  BATSelectProductCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATOTCDrugModel.h"
@class BATSelectProductCell;
@protocol BATSelectProductCellDelegate<NSObject>

- (void)BATSelectProductCellDelegateWithAddActionRowPaht:(NSIndexPath *)rowPath cell:(BATSelectProductCell *)cell;
- (void)BATSelectProductCellDelegateWithReduceActionRowPaht:(NSIndexPath *)rowPath cell:(BATSelectProductCell *)cell;


@end

@interface BATSelectProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *producterLb;
@property (weak, nonatomic) IBOutlet UILabel *salesPriceLb;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLb;

@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

@property (nonatomic,strong) NSIndexPath *rowPath;

@property (nonatomic,strong) OTCSearchData *drugModel;

@property(nonatomic,weak) id <BATSelectProductCellDelegate> delegate;

@end
