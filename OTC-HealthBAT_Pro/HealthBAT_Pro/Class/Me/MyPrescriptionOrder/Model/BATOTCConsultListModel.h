//
//  BATOTCConsultListModel.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/31.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BATOTCConsultListData,BATOTCConsultData;

@interface BATOTCConsultListModel : NSObject
@property (nonatomic, strong) NSString *ResultMessage;
@property (nonatomic, strong) NSString *ResultCode;
@property (nonatomic, strong) NSString *PageIndex;
@property (nonatomic, strong) NSString *PageSize;
@property (nonatomic, assign) NSInteger RecordsCount;
@property (nonatomic, strong) NSString *PagesCount;
@property (nonatomic, strong) NSArray<BATOTCConsultListData *> *Data;

@end


@interface BATOTCConsultListData : NSObject
@property (nonatomic, strong) NSArray<BATOTCConsultData *> *DrugInfo;

@property (nonatomic, strong) NSString *ID;  //处方ID
@property (nonatomic, strong) NSString *OrderNo; //订单号 如果存在代表已购买 如果为空则表示未购买
@property (nonatomic, strong) NSString *AccountId; //用户ID
@property (nonatomic, strong) NSString *PhoneNumber; //手机号
@property (nonatomic, strong) NSString *RecipSource; //处方来源  1 用户端 2店员端
@property (nonatomic, strong) NSString *RecipeName;//处方名称
@property (nonatomic, strong) NSString *Remark; //医嘱
@property (nonatomic, strong) NSString *RecipeFileUrl;//图片地址
@property (nonatomic, strong) NSString *RecipeDate; //处方时间
@property (nonatomic, strong) NSString *Diagnosis; //诊断结果


@end


@interface BATOTCConsultData : NSObject

@property (nonatomic, strong) NSString *DrugID; //药品ID
@property (nonatomic, strong) NSString *DrugName; //药品名称
@property (nonatomic, strong) NSString *Price;  //单价
@property (nonatomic, assign) NSInteger DrugNumber; //数量
@property (nonatomic, strong) NSString *PictureUrl;
@property (nonatomic, strong) NSString *Specification;//规格
@property (nonatomic, strong) NSString *ManufactorName; //生产厂家

@end
