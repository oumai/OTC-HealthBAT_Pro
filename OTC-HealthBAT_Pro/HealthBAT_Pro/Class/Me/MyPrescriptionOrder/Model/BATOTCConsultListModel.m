//
//  BATOTCConsultListModel.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/31.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCConsultListModel.h"

@implementation BATOTCConsultListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATOTCConsultListData class]};
}

@end

@implementation BATOTCConsultListData
+ (NSDictionary *)objectClassInArray{
    return @{@"DrugInfo" : [BATOTCConsultData class]};
}
@end


@implementation BATOTCConsultData


@end
