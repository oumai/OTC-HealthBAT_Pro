//
//  BATKmWlyyOPDRegisteListModel.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/10/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATKmWlyyOPDRegisteListData,RecipeFile;

@interface BATKmWlyyOPDRegisteListModel : NSObject

@property (nonatomic, copy  ) NSString          *Msg;

@property (nonatomic, assign) NSInteger         Result;

@property (nonatomic, assign) NSInteger         Status;

@property (nonatomic, assign) NSInteger         Total;

@property (nonatomic, strong) NSArray<BATKmWlyyOPDRegisteListData *> *Data;

@end


@interface BATKmWlyyOPDRegisteListData : NSObject

@property (nonatomic, copy  ) NSString          *MemberID;

@property (nonatomic, copy  ) NSString          *OPDDate;

@property (nonatomic, copy  ) NSString          *OPDRegisterID;

@property (nonatomic, copy  ) NSString          *OPDType;

@property (nonatomic, copy  ) NSString          *RecipeFileUrl;

@property (nonatomic, strong) NSMutableArray<RecipeFile *> *RecipeFiles;

@end

@interface RecipeFile : NSObject

@property (nonatomic, copy  ) NSString          *Amount;  //1.05

@property (nonatomic, copy  ) NSString          *BoilWay;

@property (nonatomic, copy  ) NSString          *DecoctNum;

@property (nonatomic, copy  ) NSString          *DecoctTargetWater;

@property (nonatomic, copy  ) NSString          *DecoctTotalWater;

@property (nonatomic, copy  ) NSString          *FreqDay;

@property (nonatomic, copy  ) NSString          *FreqTimes;

@property (nonatomic, copy  ) NSString          *RecipeDate;   //处方日期

@property (nonatomic, copy  ) NSString          *RecipeFileID; //处方编号

@property (nonatomic, copy  ) NSString          *RecipeFileStatus;//处方状态

@property (nonatomic, copy  ) NSString          *RecipeImgUrl;

@property (nonatomic, copy  ) NSString          *RecipeName;  //处方名称

@property (nonatomic, copy  ) NSString          *RecipeNo;

@property (nonatomic, copy  ) NSString          *RecipeType; //1=中药，2=西药

@property (nonatomic, copy  ) NSString          *RecipeTypeName;

@property (nonatomic, copy  ) NSString          *Remark;

@property (nonatomic, copy  ) NSString          *ReplaceDose;

@property (nonatomic, copy  ) NSString          *ReplacePrice;

@property (nonatomic, copy  ) NSString          *State;

@property (nonatomic, copy  ) NSString          *TCMQuantity;

@property (nonatomic, copy  ) NSString          *Times;

@property (nonatomic, copy  ) NSString          *Usage;

@end

