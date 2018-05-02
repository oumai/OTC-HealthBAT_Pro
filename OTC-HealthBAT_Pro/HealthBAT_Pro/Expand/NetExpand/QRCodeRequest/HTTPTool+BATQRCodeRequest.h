//
//  HTTPTool+BATQRCodeRequest.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATQRCodeRequest)

+ (void)requestWithQRCodeOTCURLString:(NSString *)URLString
                     parameters:(id)parameters
                           type:(XMHTTPMethodType)type
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError * error))failure;

@end
