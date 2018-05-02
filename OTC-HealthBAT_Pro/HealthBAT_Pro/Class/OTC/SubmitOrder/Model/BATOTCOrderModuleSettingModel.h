//
//  BATOTCOrderModuleSettingModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/11/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATOTCOrderModuleSettingData;
@interface BATOTCOrderModuleSettingModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATOTCOrderModuleSettingData *Data;

@end

@interface BATOTCOrderModuleSettingData : NSObject

@property (nonatomic,assign) BOOL IsCanBuy;

@property (nonatomic,assign) BOOL IsPickUpInStore;

@property (nonatomic,assign) BOOL IsHomeDelivery;

@end
