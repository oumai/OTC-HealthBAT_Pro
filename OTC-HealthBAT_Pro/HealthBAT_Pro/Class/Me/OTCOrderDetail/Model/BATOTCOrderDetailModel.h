//
//  BATOTCOrderDetailModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATOTCOrderDetailData,BATProductData;

@interface BATOTCOrderDetailModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATOTCOrderDetailData *Data;

@end

@interface BATOTCOrderDetailData : NSObject

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, copy) NSString *TradeNo;

@property (nonatomic, assign) NSInteger OrderStatus;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *DrugStoreID;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, assign) NSInteger OrderType;

@property (nonatomic, assign) NSInteger ReceiveMethod;

@property (nonatomic, copy) NSString *Freight;

@property (nonatomic, copy) NSString *OrderMoney;

@property (nonatomic, copy) NSString *Receiver;

@property (nonatomic, copy) NSString *ReceiverMobile;

@property (nonatomic, copy) NSString *ReceiverAddress;

@property (nonatomic, copy) NSString *FetchCode;

@property (nonatomic, copy) NSString *FetchTime;

@property (nonatomic, copy) NSString *AccountMobile;

@property (nonatomic, copy) NSString *TrackingNumber;

@property (nonatomic,strong) NSMutableArray <BATProductData*>* ProductList;

/**
 二维码图
 */
@property (nonatomic,strong) UIImage *qrCodeImage;

@end

@interface BATProductData : NSObject

@property (nonatomic, copy) NSString *ProductName;

@property (nonatomic, copy) NSString *ProductNum;

@property (nonatomic, copy) NSString *ProductImage;

@property (nonatomic, copy) NSString *ProductPrice;

@property (nonatomic, copy) NSString *Specification;

@property (nonatomic, copy) NSString *ManufactorName;

@end
