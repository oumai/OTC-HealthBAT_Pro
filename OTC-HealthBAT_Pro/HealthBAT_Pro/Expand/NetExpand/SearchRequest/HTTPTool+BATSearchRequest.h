//
//  HTTPTool+BATSearchRequest.h
//  HealthBAT_Pro
//
//  Created by KM on 16/8/302016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATSearchRequest)

/**
 *  搜索接口
 *
 *  @param URLString  url
 *  @param parameters 参数
 *  @param success    成功
 *  @param failur     失败
 */
+ (void)requestWithSearchURLString:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError * error))failur;

@end
