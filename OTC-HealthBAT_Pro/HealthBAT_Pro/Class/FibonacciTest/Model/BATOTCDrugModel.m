//
//  BATOTCDrugModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCDrugModel.h"

@implementation BATOTCDrugModel
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [OTCSearchData class]};
}

@end


@implementation OTCSearchData
MJExtensionCodingImplementation
@end

