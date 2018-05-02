//
//  BATKangDoctorModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/2/172017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class DrKangResultdata;

@interface BATDrKangModel : NSObject

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, strong) DrKangResultdata *resultData;

@end

@interface DrKangResultdata : NSObject

@property (nonatomic,strong) NSString *body;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSArray *symptomList;

@end
