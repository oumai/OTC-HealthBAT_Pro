//
//  BATKmWlyyOPDRegisteListModel.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/10/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATKmWlyyOPDRegisteListModel.h"

@implementation BATKmWlyyOPDRegisteListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATKmWlyyOPDRegisteListData class]};
}

@end

@implementation BATKmWlyyOPDRegisteListData

+ (NSDictionary *)objectClassInArray{
    return @{@"RecipeFiles" : [RecipeFile class]};
}

@end

@implementation RecipeFile

@end
