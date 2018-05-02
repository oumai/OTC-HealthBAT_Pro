//
//  BATMyPrescriptionModel.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OTCMyPrescriptionData;
@class OTCMyRecipeFilesData;


@interface BATMyPrescriptionModel : NSObject

@property (nonatomic, strong) NSString *OPDRegisterID;  //预约ID
@property (nonatomic, strong) NSString *UserID;         //用户ID
@property (nonatomic, strong) NSString *RegDate;        //预约日期
@property (nonatomic, strong) NSString *OPDDate;        //排班日期
@property (nonatomic, strong) NSString *ConsultContent; //病情描述
@property (nonatomic, strong) NSArray<OTCMyPrescriptionData *> *Data;

@end



@interface OTCMyPrescriptionData : NSObject



@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *DSID;

@property (nonatomic, copy) NSString *CodeIds;

@property (nonatomic, copy) NSString *CodeValues;

@property (nonatomic, copy) NSString *DrugName;

@property (nonatomic, copy) NSString *DrugAlias;

@property (nonatomic, copy) NSString *PictureUrl;

@property (nonatomic, copy) NSString *ApprovalNumber;

@property (nonatomic, copy) NSString *ArtNo;

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

@property (nonatomic, copy) NSString *ManufactorName;

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

@property(nonatomic,assign) NSInteger drugCount;

@property (nonatomic,assign) BOOL isSelect;


@end

@interface OTCMyRecipeFilesData : NSObject

@property (nonatomic, strong) NSString *RecipeFileID; //处方编号
@property (nonatomic, strong) NSString *RecipeDate;  //处方日期
@property (nonatomic, strong) NSString *RecipeFileStatus;//处方状态
@property (nonatomic, strong) NSString *RecipeName;     //处方名称
@property (nonatomic, strong) NSString *RecipeType;  //1=中药，2=西药
@property (nonatomic, strong) NSString *Amount;

@end
