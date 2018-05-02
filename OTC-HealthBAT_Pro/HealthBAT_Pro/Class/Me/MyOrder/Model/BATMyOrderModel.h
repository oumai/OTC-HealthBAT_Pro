//
//  BATMyOrderModel.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATMyOrderModel : NSObject

@property (nonatomic, strong) NSString *ResultMessage;
@property (nonatomic, assign) NSInteger PagesCount;
@property (nonatomic, assign) NSInteger PageIndex;
@property (nonatomic, assign) NSInteger PageSize;
@property (nonatomic, assign) NSInteger ResultCode;
@end


@interface BATMyOrderData : NSObject

@property (nonatomic, strong) NSString *OrderNo;
@property (nonatomic, strong) NSString *OrderStatus;
@property (nonatomic, strong) NSString *FetchCode;
@property (nonatomic, strong) NSString *CreatedTime;
@property (nonatomic, strong) NSString *ProductList;



@end



@interface BATMyOrderModelData : NSObject

@property (nonatomic, strong) NSString *ProductID;
@property (nonatomic, strong) NSString *ProductName;
@property (nonatomic, strong) NSString *ProductNum;
@property (nonatomic, strong) NSString *ProductImage;
@property (nonatomic, strong) NSString *ProductPrice;



@end
