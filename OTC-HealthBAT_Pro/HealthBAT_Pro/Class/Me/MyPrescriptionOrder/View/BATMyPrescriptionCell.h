//
//  BATMyPrescriptionCell.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEIQIA_TTTAttributedLabel.h"
//#import "BATKmWlyyOPDRegisteListModel.h"


#import "BATOTCConsultListModel.h"
@interface BATMyPrescriptionCell : UITableViewCell

@property (nonatomic, strong) void(^buyButtonBlock)(BATMyPrescriptionCell *cell,NSIndexPath*pathRows);
@property (nonatomic, strong) void(^checkButtonBlock)(BATMyPrescriptionCell *cell,NSIndexPath*pathRows);

@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic, strong) TTTAttributedLabel *timeLabel;
@property (nonatomic, strong) TTTAttributedLabel *titleLabel; //诊断
@property (nonatomic, strong) TTTAttributedLabel *detailLabel;
@property (nonatomic, strong) NSString *detailString;
@property (nonatomic, strong) NSString *OrderNo;

//@property (nonatomic, strong) BATKmWlyyOPDRegisteListData *model;
@property (nonatomic, strong) BATOTCConsultListModel *model;



+ (CGFloat) heightForCellWithString:(NSString *)string;

@end
