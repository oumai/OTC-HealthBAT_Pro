//
//  PharmacyOrderListModel.h
//  KMTestHalthyManage
//
//  Created by woaiqiu947 on 2017/10/25.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "OTCDrugData.h"

@class OTCDrugListData;
@interface PharmacyOrderListModel : NSObject
@property (nonatomic, assign) NSInteger    ResultCode;

@property (nonatomic, assign) NSInteger    RecordsCount;

@property (nonatomic, copy  ) NSString     *ResultMessage;

@property (nonatomic, assign) NSInteger    PageIndex;

@property (nonatomic, assign) NSInteger    PageSize;

@property (nonatomic, strong) NSArray <OTCDrugListData*> *Data;
@end

@interface OTCDrugListData : NSObject

@property (nonatomic, copy  ) NSString     *OrderNo;

@property (nonatomic, assign) NSInteger    OrderStatus;

@property (nonatomic, copy  ) NSString     *FetchCode;

@property (nonatomic, copy  ) NSString     *CreatedTime;

@property (nonatomic, strong) NSArray <OTCDrugData*> *ProductList;

@end

