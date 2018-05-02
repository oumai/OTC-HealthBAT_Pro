//
//  BATWebContentModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WebContentData;

@interface BATWebContentModel : NSObject

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *holeString;

@property (nonatomic, strong) NSArray<WebContentData *> *Data;

@end

@interface WebContentData : NSObject

@property (nonatomic, copy) NSString *CreatedBy;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *EvaluationTempID;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *IsDeleted;

@property (nonatomic, copy) NSString *LastModifiedBy;

@property (nonatomic, copy) NSString *LastModifiedTime;

@property (nonatomic, copy) NSString *MaxScores;

@property (nonatomic, copy) NSString *MinScores;

@property (nonatomic, copy) NSString *Recommend;

@property (nonatomic, copy) NSString *Result;

@property (nonatomic, copy) NSString *ResultDesc;


@end
