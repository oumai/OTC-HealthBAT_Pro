//
//  HTTPTool+BATQRCodeRequest.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATQRCodeRequest.h"
#import "MF_Base64Additions.h"

@implementation HTTPTool (BATQRCodeRequest)

+ (void)requestWithQRCodeOTCURLString:(NSString *)URLString
                     parameters:(id)parameters
                           type:(XMHTTPMethodType)type
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError * error))failure
{
    
    [XMCenter sendRequest:^(XMRequest *request) {
        request.server = OTC_URL;
        request.api = URLString;
        request.parameters = parameters;
        if (LOGIN_STATION) {
            request.headers = @{@"Token":LOCAL_TOKEN};
        }
        request.httpMethod = type;
        request.requestSerializerType = kXMRequestSerializerJSON;
        request.responseSerializerType = kXMResponseSerializerRAW;
    } onSuccess:^(id responseObject) {
        
        
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData *data = [[NSData alloc] initWithData:[NSData dataWithBase64String:string]];
        
        if (data) {
            if (success) {
                success(data);
            }
        } else {
            if (failure) {
                NSError * tmpError = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"啊哦，无法连线上网",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
                failure(tmpError);
            }
        }
        
        
    } onFailure:^(NSError *error) {
        
        if (failure) {
            NSError * tmpError = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"啊哦，无法连线上网",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
            failure(tmpError);
        }
        
    } onFinished:^(id responseObject, NSError *error) {
        
        
    }];
    
}

@end
