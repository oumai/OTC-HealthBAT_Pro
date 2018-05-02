//
//  BATKmWlyyOPDRegisteModel.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/10/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATKmWlyyOPDRegisteData;

@interface BATKmWlyyOPDRegisteModel : NSObject

@property (nonatomic, copy  ) NSString          *Msg;

@property (nonatomic, assign) NSInteger         Result;

@property (nonatomic, assign) NSInteger         Status;

@property (nonatomic, assign) NSInteger         Total;

@property (nonatomic, strong) BATKmWlyyOPDRegisteData *Data;

@end


@interface BATKmWlyyOPDRegisteData : NSObject

@property (nonatomic, copy  ) NSString          *ActionStatus;

@property (nonatomic, copy  ) NSString          *ChannelID;

@property (nonatomic, copy  ) NSString          *ErrorInfo;

@property (nonatomic, copy  ) NSString          *OPDRegisterID;

@property (nonatomic, copy  ) NSString          *OrderNO;

@property (nonatomic, assign) NSInteger         OrderState;

@end
