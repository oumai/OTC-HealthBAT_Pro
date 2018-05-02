//
//  BATOTCDrugCellTableViewCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATOTCDrugModel.h"
@class BATOTCDrugCellTableViewCell;
@protocol BATOTCDrugCellTableViewCellDelegate<NSObject>

- (void)BATOTCDrugCellTableViewCellDelegateWithAddActionRowPaht:(NSIndexPath *)rowPath cell:(BATOTCDrugCellTableViewCell *)cell;
- (void)BATOTCDrugCellTableViewCellDelegateWithReduceActionRowPaht:(NSIndexPath *)rowPath cell:(BATOTCDrugCellTableViewCell *)cell;


@end

@interface BATOTCDrugCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *drugName;
@property (weak, nonatomic) IBOutlet UILabel *producterName;
@property (weak, nonatomic) IBOutlet UILabel *salesPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

@property (nonatomic,strong) NSIndexPath *rowPath;

@property (nonatomic,weak) id<BATOTCDrugCellTableViewCellDelegate> delegate;

@property (nonatomic,strong) OTCSearchData *drugModel;

@end
