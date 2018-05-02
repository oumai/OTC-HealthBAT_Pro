//
//  BATDrKangSoundTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 17/2/222017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDrKangMessageModel.h"

@interface BATDrKangSoundTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIImageView *bubbleImageView;
@property (nonatomic,strong) UIImageView *trumpetImageView;
@property (nonatomic,strong) UILabel *audioDurationLabel;

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,copy) void(^audioPlayerBlock)(void);

- (void)setMessageModel:(BATDrKangMessageModel *)messageModel;

@end
