//
//  BATOTCDrugModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class OTCSearchData;

@interface BATOTCDrugModel : NSObject

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, strong) NSArray<OTCSearchData *> *Data;


@end

@interface OTCSearchData : NSObject

/**
 药品id
 */
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *DSID;

@property (nonatomic, copy) NSString *CodeIds;

@property (nonatomic, copy) NSString *CodeValues;

/**
 药品名称
 */
@property (nonatomic, copy) NSString *DrugName;

@property (nonatomic, copy) NSString *DrugAlias;

/**
 药品图片
 */
@property (nonatomic, copy) NSString *PictureUrl;

@property (nonatomic, copy) NSString *ApprovalNumber;

@property (nonatomic, copy) NSString *ArtNo;

/**
 规格
 */
@property (nonatomic, copy) NSString *Specification;

@property (nonatomic, copy) NSString *Indications;

@property (nonatomic, copy) NSString *Precautions;

@property (nonatomic, copy) NSString *Instructions;

@property (nonatomic, copy) NSString *Sideeffects;

@property (nonatomic, copy) NSString *UnsuitablePeople;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, assign) NSInteger DrugType;

@property (nonatomic, assign) BOOL IsMedinsurance;

@property (nonatomic, assign) BOOL IsEphedrine;

@property (nonatomic, assign) BOOL IsOTC;

/**
 厂家
 */
@property (nonatomic, copy) NSString *ManufactorName;

/**
 药品价格
 */
@property (nonatomic, copy) NSString *Price;

@property (nonatomic, copy) NSString *DosageForm;

@property (nonatomic, copy) NSString *RelatedDiseasesList;

@property (nonatomic, copy) NSString *RelatedDiseasesNList;

@property (nonatomic, copy) NSString *Composition;

@property (nonatomic, copy) NSString *WomenMedication;

@property (nonatomic, copy) NSString *ChildMedication;

@property (nonatomic, copy) NSString *ElderlyMedication;

@property (nonatomic, copy) NSString *DrugInteraction;

@property (nonatomic, copy) NSString *Notice;

@property (nonatomic, copy) NSString *ChineseDrug;

@property (nonatomic, copy) NSString *OTCType;

@property (nonatomic, assign) NSInteger OrderNum;

@property (nonatomic, assign) BOOL IsRecommended;

@property (nonatomic, assign) NSInteger State;

@property (nonatomic, assign) BOOL IsDeleted;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *LastModifiedTime;

@property (nonatomic, assign) NSInteger StockOnLine;

/**
 药品购买数量
 */
@property(nonatomic,assign) NSInteger drugCount;

@property (nonatomic,assign) BOOL isSelect;

@end




