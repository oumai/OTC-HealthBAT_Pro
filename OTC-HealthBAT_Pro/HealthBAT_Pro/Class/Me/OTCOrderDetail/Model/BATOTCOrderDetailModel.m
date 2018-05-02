//
//  BATOTCOrderDetailModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCOrderDetailModel.h"

@implementation BATOTCOrderDetailModel

@end

@implementation BATOTCOrderDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"ProductList" : [BATProductData class]};
}

@end

@implementation BATProductData

@end
