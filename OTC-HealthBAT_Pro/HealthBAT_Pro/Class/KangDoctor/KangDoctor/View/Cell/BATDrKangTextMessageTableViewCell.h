//
//  BATKangDoctorTextMessageTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDrKangMessageModel.h"

@interface BATDrKangTextMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIImageView *bubbleImageView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIActivityIndicatorView *sendingIndicator;
@property (nonatomic,strong) UIImageView *failureImageView;

@property (nonatomic,strong) UILabel *timeLabel;

- (void)setMessageModel:(BATDrKangMessageModel *)messageModel;

@end
