//
//  OTCLoginModel.h
//  KMTestHalthyManage
//
//  Created by shipeiyuan on 2017/8/23.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class OTCLoginData;
@interface OTCLoginModel : NSObject
@property (nonatomic, assign) NSInteger    PagesCount;

@property (nonatomic, assign) NSInteger    ResultCode;

@property (nonatomic, assign) NSInteger    RecordsCount;

@property (nonatomic, copy  ) NSString     *ResultMessage;

@property (nonatomic, assign) BOOL         AllowPaging;

@property (nonatomic, strong) OTCLoginData *Data;
@end

@interface OTCLoginData : NSObject

@property (nonatomic, copy  ) NSString     *ID;

@property (nonatomic, copy  ) NSString     *AccountName;

@property (nonatomic, copy  ) NSString     *StoreName;

@property (nonatomic, copy  ) NSString     *StoreId;

@property (nonatomic, copy  ) NSString     *Mobile;

@property (nonatomic, copy  ) NSString     *Address;

@property (nonatomic, copy  ) NSString     *Lat;

@property (nonatomic, copy  ) NSString     *Lon;

@property (nonatomic, copy  ) NSString     *Pic;

@property (nonatomic, copy  ) NSString     *Token;

@end
