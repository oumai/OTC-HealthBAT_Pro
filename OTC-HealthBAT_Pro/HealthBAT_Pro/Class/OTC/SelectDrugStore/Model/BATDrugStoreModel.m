//
//  BATDrugStoreModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugStoreModel.h"

@implementation BATDrugStoreModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATDrugStoreData class]};
}

@end

@implementation BATDrugStoreData

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID" : @"Id",
             };
}

@end
