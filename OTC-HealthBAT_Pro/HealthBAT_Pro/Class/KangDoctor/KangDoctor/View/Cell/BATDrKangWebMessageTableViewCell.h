//
//  BATKangDoctorMessageTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDrKangMessageModel.h"

@interface BATDrKangWebMessageTableViewCell : UITableViewCell<UITextViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIImageView *bubbleImageView;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) UILabel *timeLabel;


@property (nonatomic,copy) void(^requestBlock)(NSDictionary *dic);

- (void)setMessageModel:(BATDrKangMessageModel *)messageModel;

@end
