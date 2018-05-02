//
//  BATKangDoctorMessageModel.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 2017/1/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//


/**
 康博士消息来源

 - BATKangDoctorMessageFromMe: 来自自己
 - BATKangDoctorMessageFromKangDoctor: 来自康博士
 */
typedef NS_ENUM(NSInteger, BATKangDoctorMessageFromType) {
    BATKangDoctorMessageFromMe = 1,
    BATKangDoctorMessageFromKangDoctor = 2,
};

#define DrKangMaxWidth ([UIScreen mainScreen].bounds.size.width-((20+45+5+10)*2)-20)

#import <Foundation/Foundation.h>
#import "BATDrKangModel.h"

@interface BATDrKangMessageModel : NSObject

@property (nonatomic,assign) BATKangDoctorMessageFromType fromType;

//内容
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableAttributedString *htmlAttributedStr;
@property (nonatomic,assign) CGFloat textHeight;
@property (nonatomic,assign) CGFloat textWidth;

@property (nonatomic,assign) float maxWidth;
@property (nonatomic,assign) NSInteger messageIndex;

//类型
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) int musicIndex;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isPlayed;

//时间
@property (nonatomic,assign) BOOL isTimeVisible;
@property (nonatomic,strong) NSDate *time;

@property (nonatomic,strong) NSDictionary *historyKeyValues;
@property (nonatomic,assign) BOOL isFail;

- (instancetype)init;

- (void)setDrkangModel:(BATDrKangModel *)model;

@end
