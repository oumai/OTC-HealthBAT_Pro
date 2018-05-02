//
//  BATgetPayOPDRegisterModel.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BATgetPayOPDRegisterData;


@interface BATgetPayOPDRegisterModel : NSObject

@property (nonatomic, strong) NSString *ResultMessage;
@property (nonatomic, strong) NSString *ResultCode;
@property (nonatomic, strong) NSArray<BATgetPayOPDRegisterData *> *Data;
@end


@interface BATgetPayOPDRegisterData : NSObject



@end

