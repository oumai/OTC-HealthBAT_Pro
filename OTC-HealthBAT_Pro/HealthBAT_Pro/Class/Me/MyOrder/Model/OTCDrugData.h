//
//  OTCDrugData.h
//  KMTestHalthyManage
//
//  Created by woaiqiu947 on 2017/10/25.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface OTCDrugData : NSObject

@property (nonatomic, copy  ) NSString     *ProductID;

@property (nonatomic, copy  ) NSString     *ProductName;

@property (nonatomic, assign  ) NSInteger     ProductNum;

@property (nonatomic, copy  ) NSString     *ProductImage;

@property (nonatomic, copy  ) NSString     *ProductPrice;

@property (nonatomic, copy) NSString *Specification;

@end
