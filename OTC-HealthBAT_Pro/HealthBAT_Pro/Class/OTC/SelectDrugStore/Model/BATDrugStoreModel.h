//
//  BATDrugStoreModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATDrugStoreData;
@interface BATDrugStoreModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray<BATDrugStoreData *> *Data;

@end

@interface BATDrugStoreData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger AccountId;

@property (nonatomic, copy) NSString *StoreName;

@property (nonatomic, copy) NSString *Pic;

@property (nonatomic, copy) NSString *Lat;

@property (nonatomic, copy) NSString *Lon;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *Distance;

@property (nonatomic, assign) BOOL IsDrug;

@end
