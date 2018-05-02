//
//  PharmacyOrderListModel.m
//  KMTestHalthyManage
//
//  Created by woaiqiu947 on 2017/10/25.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "PharmacyOrderListModel.h"

@implementation PharmacyOrderListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"Data": [OTCDrugListData class]};
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self mj_decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [self mj_encode:encoder];
}
@end

@implementation OTCDrugListData

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"ProductList": [OTCDrugData class]};
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self mj_decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [self mj_encode:encoder];
}
@end
