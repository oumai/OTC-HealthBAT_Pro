//
//  HTTPTool+BATOTCRequest.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATOTCRequest)

+ (void)requestWithOTCURLString:(NSString *)URLString
                     parameters:(id)parameters
                           type:(XMHTTPMethodType)type
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError * error))failure;

@end
